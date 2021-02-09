Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927653151ED
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 15:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhBIOqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 09:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbhBIOq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 09:46:27 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7872EC061786
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 06:45:46 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id hs11so32036308ejc.1
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 06:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KQ2Sbsh04NFaMe71kNZxj3e0nFEQR1f+t3TxK0bVaIo=;
        b=IPcimyS8NbOXMW/+bKdpJJPvlCvWUJhtBDm8ZGJwjbztAv7DdLG2t5mmtNxbYBGxlw
         dR4mRiTUMWbtyXJARz3qcsEp5PnAHF29vaxNUAvKDqdevswx9V6iyKqASySH1vGFcMRt
         tOQCnwoxeofpXqfhgr/RsP+NBr6McLBSgfzBC6SxsqxepOP4VI+WKEzGvKqKiiGQOwhM
         FQ23/Ze3hLIAVpkIajfqF0/kcyUNC2Fc3Fq6o+38aJkdopYuRhP+OHzVEQrtfLA/KMWR
         ur4NaL3lrWbY0LpdnRRjskhQDBKxE2RMDtluQ7InzYTwXD/sVHjwaSE2hygM1X8F8TJx
         x+4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KQ2Sbsh04NFaMe71kNZxj3e0nFEQR1f+t3TxK0bVaIo=;
        b=MaCEi8zSRfqY7jeys4biFx4vdOlJMsn9+1adWc8sDwkRGw66PS/J62sSD4oqk7dnEO
         orJePMTLeYOPOmXUN7VlGL+NKgcGkqItQJHSqgQ9rxWWKj8iVjdS5ZInPL15BRqPWl4U
         vuN0+T2hStsbqYP8tcuTTF3zP7DH8ZpkPX3S7ZvSUePL/bcsNr5Ys3fbglzZ711uR7Q3
         hY4FqoyP8H9A/SbdgSC5JCaYclBuMBlMgDQPDL2Et4OQLxgqo91qbIqMpu3xVOHjPfM5
         HrPHe0/VGGhVlgTk4876rx5butDaP5NxMYY3UHOT/aaPMJR5WbUj1ZaAQ72J7xrETKqR
         Sifg==
X-Gm-Message-State: AOAM530qEW8Lf6KlcMVGK+HNqCZI0V/n6EkkU8lM3eeAyrAUxAvGNTQJ
        rSHEthHlTimmXau035fCtnI+RTMYOvGpO3pVBW4=
X-Google-Smtp-Source: ABdhPJya2ASH85/oSguA4zNcrElGMNzUMUdXJzr+Up1XiFO445bGVGBxLDiqJcrTDOOfw4OhG+rvnm75yFYsPu3khHc=
X-Received: by 2002:a17:906:4dc5:: with SMTP id f5mr22394477ejw.11.1612881945274;
 Tue, 09 Feb 2021 06:45:45 -0800 (PST)
MIME-Version: 1.0
References: <20210208185558.995292-1-willemdebruijn.kernel@gmail.com>
 <20210208185558.995292-4-willemdebruijn.kernel@gmail.com> <20210209044125-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210209044125-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 9 Feb 2021 09:45:08 -0500
Message-ID: <CAF=yD-LepCKmpRbQyHP5+61ewCSpwOHmsQm_GNBcTi03Z5knXA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 3/4] virtio-net: support transmit timestamp
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 4:43 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Feb 08, 2021 at 01:55:57PM -0500, Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > Add optional PTP hardware tx timestamp offload for virtio-net.
> >
> > Accurate RTT measurement requires timestamps close to the wire.
> > Introduce virtio feature VIRTIO_NET_F_TX_TSTAMP, the transmit
> > equivalent to VIRTIO_NET_F_RX_TSTAMP.
> >
> > The driver sets VIRTIO_NET_HDR_F_TSTAMP to request a timestamp
> > returned on completion. If the feature is negotiated, the device
> > either places the timestamp or clears the feature bit.
> >
> > The timestamp straddles (virtual) hardware domains. Like PTP, use
> > international atomic time (CLOCK_TAI) as global clock base. The driver
> > must sync with the device, e.g., through kvm-clock.
> >
> > Modify can_push to ensure that on tx completion the header, and thus
> > timestamp, is in a predicatable location at skb_vnet_hdr.
> >
> > RFC: this implementation relies on the device writing to the buffer.
> > That breaks DMA_TO_DEVICE semantics. For now, disable when DMA is on.
>
> If you do something like this, please do it in the validate
> callback and clear the features you aren't using.

Ah yes. Thanks for the tip. I'll do that ..

.. once I'm sure that this approach of using an outbuf for I/O is
actually allowed behavior. I'm not entirely convinced yet myself.
Jason also pointed out more specific concerns. I'll look into that
further.
