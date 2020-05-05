Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570551C64B3
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 01:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbgEEX7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 19:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728875AbgEEX7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 19:59:54 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB6FC061A0F;
        Tue,  5 May 2020 16:59:54 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id c3so3299015otp.8;
        Tue, 05 May 2020 16:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M/lOXwJ10lZREjH/g0nBHnRAQAxDlzXtqSNjgFSkMmY=;
        b=dR428xa5XKa4gysK0zL+lRz9rkpXqI7TLC1PUnRmhcGUU4RtTcCOdSrHvB3Ouqd1xI
         9HTlwQXl8kQY9tIToyHqvb874JrRAeNX/MXafaq6hJIro/mudyF75ROZo0AQ9V4lGFT1
         t+QFnAnfZx8JxmcPZMNNVJar1Navzxsca+uNgfuwbL7vMgKUt2OSFhA8kDMOXOmd/bsZ
         1EBdehvkuMw2cVSVZ2fg3Ssb68lOlJyf0PJkIGQpA9WlCt3F6u4S8ziZiL+XM/t8lUoq
         b6gl4TuLYyFe+SAnkrj2dh6APEoqsWiejVzy0tp7SyIpf17OvZQQSLriI3WuFm1m1gbe
         c3mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M/lOXwJ10lZREjH/g0nBHnRAQAxDlzXtqSNjgFSkMmY=;
        b=a4j5RVd7+K+USkxNwKmcgLcmNTkEpCRF2yEm9nK8O3YaU/vjPHwoL2uJhAlfrDydwY
         AVPEFjrL4G4S1/zX8xGXHvawfDp6pdxXXBSWPXh5VF4J+cDN6WAwKU/v/pwFHaJ7qxLb
         j3JyCkSjTOqs9kHkucfk2JnokY4dkIlK6WtxJXiAFxBxeooBF7iiPyEixnezoLtEdfc/
         N89wfYGik3873On59JrZhNhXagg3RUGoJEhi2MCgbO4diJtSODfNecHc+lvIi5PicvOx
         dc2HW4ER9clmFCn6TCGCBKAcCAwivA2cYP5IGxM8bEk6VichDn/TdUqcZMxowPNwQZes
         A4Ww==
X-Gm-Message-State: AGi0PuZ8lahE3IkB9qxGnjkASXMTO1h5ZQPB0vAWrk5g35UB9F47TeKd
        AgrgWlS6BrqltcP1uj2+GmLAvLDDyeap6PTU+vfUFi1i
X-Google-Smtp-Source: APiQypK5yu0INLelHDFEoDo2+85jy01veAwNyMWOG+XMporp0ozwgFbu+F8lCl/ZC3al+2cvPkWwB3ZetGlbfobhZ6A=
X-Received: by 2002:a9d:57cb:: with SMTP id q11mr4639813oti.11.1588723194213;
 Tue, 05 May 2020 16:59:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200414115512.1.I9dd050ead919f2cc3ef83d4e866de537c7799cf3@changeid>
 <DF70A2DA-9E5F-4524-8F20-2EC7CF70597F@holtmann.org>
In-Reply-To: <DF70A2DA-9E5F-4524-8F20-2EC7CF70597F@holtmann.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 5 May 2020 16:59:43 -0700
Message-ID: <CABBYNZ+1XLttkvoBzLR6iCguB2Atrr0+PA5isnD9Cg2af2TFKA@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Terminate the link if pairing is cancelled
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Manish Mandlik <mmandlik@google.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish, Marcel,

On Tue, Apr 28, 2020 at 2:38 AM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Manish,
>
> > If user decides to cancel ongoing pairing process (e.g. by clicking
> > the cancel button on the pairing/passkey window), abort any ongoing
> > pairing and then terminate the link.
> >
> > Signed-off-by: Manish Mandlik <mmandlik@google.com>
> > ---
> > Hello Linux-Bluetooth,
> >
> >  This patch aborts any ongoing pairing and then terminates the link
> >  by calling hci_abort_conn() in cancel_pair_device() function.
> >
> >  However, I'm not very sure if hci_abort_conn() should be called here
> >  in cancel_pair_device() or in smp for example to terminate the link
> >  after it had sent the pairing failed PDU.
> >

Id recommend leaving the hci_abort_conn out since that is a policy
decision the userspace should be in charge to decide if the link
should be disconnected or not.

> >  Please share your thoughts on this.
>
> I am look into this. Just bare with me for a bit to verify the call chain.
>
> Regards
>
> Marcel
>


-- 
Luiz Augusto von Dentz
