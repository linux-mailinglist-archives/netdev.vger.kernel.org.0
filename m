Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15FE6305581
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S317004AbhAZXNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727718AbhAZWB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 17:01:27 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D5FC061574
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 14:00:47 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id p20so71608vsq.7
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 14:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mTApDKOxeOU29z1mIGyQ3U5kW/vB96rDW6pLyQgLPTQ=;
        b=aIhSXZqpMJtxO0qxSMehJclZGY0CJFsDlmikGOtnLQwzWblhw58A67+5YoUm5mVpNv
         nawc8yUjOYdYwY2kwFHqHl//p/gMYvu/qAHW8VDWgj9KVqdACVC3Z2GF/wtbTZFauVj+
         RF0jOCkdJYk9HcxagOEzDv1JSBzbNZix+Cp9dkEMSrcZVKxQiSG0voV6IOePH1i6uOSP
         siBNteYDBsQmlk75/zGmU1ug9eXOpzqbhLuBUCobtMZaMXNXXoE/h3oWK8LhWrEp5/Sn
         ZPdRAFHvmluCd+ukNdcU0FHba/YCvaWJsVFdNbmTV+vs9a0vrOeN19tsWcYbidxOOAIt
         JOBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mTApDKOxeOU29z1mIGyQ3U5kW/vB96rDW6pLyQgLPTQ=;
        b=RjvRAXxjrK1OnFtsMl2eh2m6EQ0fzun8QpT0Hf0ZL8Q13VOhVIWTmKAyQmXulhfYpM
         rUru3qm8C7nI9/WW7Mz+9aRZy7/0UvidsLIPu7SR6KKXegYNrr9Ylg/ouADv7KAznMco
         i+iUuEtfkY8rjzA6mIUZhbJHKor68sYMLZ6VKzdDRpFI8sUywojDMBte5wqivjSqr8a+
         YxfL8LuiY5BnFtG8/uwsOqhTUpjhoO8/l1ofghDl0B/cRA9SGjYc1qywSuxK4dUm8sqh
         0XqRRWRng7LHpKhNSg9sICChau4llAFfBT/89KUfYg6bQD9vBZMeDXBww8l2ggQc/6S7
         lOcQ==
X-Gm-Message-State: AOAM532hybVUEshlD0NHBpnb0fsHocNGaYjwRLLNPAzUZbtR8IC1NLwX
        JkEmqCodBjEhUQzrWCrjyxt6JgCBr4E=
X-Google-Smtp-Source: ABdhPJzlJleuVGyH/IMmJwfklvpZB4Fb69m/UTgXl0kymc49fRIWLYOmR99PXFmerC8ubw+/fNNNZA==
X-Received: by 2002:a67:2a46:: with SMTP id q67mr6604774vsq.40.1611698445585;
        Tue, 26 Jan 2021 14:00:45 -0800 (PST)
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com. [209.85.221.172])
        by smtp.gmail.com with ESMTPSA id t16sm22959vke.28.2021.01.26.14.00.44
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 14:00:44 -0800 (PST)
Received: by mail-vk1-f172.google.com with SMTP id u22so45929vke.9
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 14:00:44 -0800 (PST)
X-Received: by 2002:a1f:2f81:: with SMTP id v123mr6342256vkv.24.1611698443554;
 Tue, 26 Jan 2021 14:00:43 -0800 (PST)
MIME-Version: 1.0
References: <20210126141248.GA27281@optiplex> <CA+FuTSez-w-Y6LfXxEcqbB5QucPRfCEFmCd5a4LtOGcyOjGOug@mail.gmail.com>
In-Reply-To: <CA+FuTSez-w-Y6LfXxEcqbB5QucPRfCEFmCd5a4LtOGcyOjGOug@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 26 Jan 2021 17:00:07 -0500
X-Gmail-Original-Message-ID: <CA+FuTSd_=nL7sycEYKSUbGVoC56V3Wyc=zLMo+mQ9mjC4i8_gw@mail.gmail.com>
Message-ID: <CA+FuTSd_=nL7sycEYKSUbGVoC56V3Wyc=zLMo+mQ9mjC4i8_gw@mail.gmail.com>
Subject: Re: UDP implementation and the MSG_MORE flag
To:     oliver.graute@gmail.com
Cc:     Network Development <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 4:54 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Tue, Jan 26, 2021 at 9:58 AM Oliver Graute <oliver.graute@gmail.com> wrote:
> >
> > Hello,
> >
> > we observe some unexpected behavior in the UDP implementation of the
> > linux kernel.
> >
> > Some UDP packets send via the loopback interface are dropped in the
> > kernel on the receive side when using sendto with the MSG_MORE flag.
> > Every drop increases the InCsumErrors in /proc/self/net/snmp. Some
> > example code to reproduce it is appended below.
> >
> > In the code we tracked it down to this code section. ( Even a little
> > further but its unclear to me wy the csum() is wrong in the bad case)
> >
> > udpv6_recvmsg()
> > ...
> > if (checksum_valid || udp_skb_csum_unnecessary(skb)) {
> >                 if (udp_skb_is_linear(skb))
> >                         err = copy_linear_skb(skb, copied, off, &msg->msg_iter);
> >                 else
> >                         err = skb_copy_datagram_msg(skb, off, msg, copied);
> >         } else {
> >                 err = skb_copy_and_csum_datagram_msg(skb, off, msg);
> >                 if (err == -EINVAL) {
> >                         goto csum_copy_err;
> >                 }
> >         }
> > ...
> >
>
> Thanks for the report with a full reproducer.
>
> I don't have a full answer yet, but can reproduce this easily.
>
> The third program, without MSG_MORE, builds an skb with
> CHECKSUM_PARTIAL in __ip_append_data. When looped to the receive path
> that ip_summed means no additional validation is needed. As encoded in
> skb_csum_unnecessary.
>
> The first and second programs are essentially the same, bar for a
> slight difference in length. In both cases packet length is very short
> compared to the loopback device MTU. Because of MSG_MORE, these
> packets have CHECKSUM_NONE.
>
> On receive in
>
>   __udp4_lib_rcv()
>     udp4_csum_init()
>       err = skb_checksum_init_zero_check()
>
> The second program validates and sets ip_summed = CHECKSUM_COMPLETE
> and csum_valid = 1.
> The first does not, though err == 0.
>
> This appears to succeed consistently for packets <= 68B of payload,
> fail consistently otherwise. It is not clear to me yet what causes
> this distinction.

This is from

"
/* For small packets <= CHECKSUM_BREAK perform checksum complete directly
 * in checksum_init.
 */
#define CHECKSUM_BREAK 76
"

So the small packet gets checksummed immediately in
__skb_checksum_validate_complete, but the larger one does not.

Question is why the copy_and_checksum you pointed to seems to fail checksum.
