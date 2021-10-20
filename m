Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5948434EBA
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 17:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhJTPOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 11:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbhJTPOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 11:14:06 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C675CC061749
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 08:11:51 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id t9so15784471lfd.1
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 08:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=ex70dGEef5Ctoy83Pz7cxdcGJqsgvDVsEg6q5HLmBIU=;
        b=KoyiafT88yljlgxWRFqZxfnBa9+0DHUYmeFo1/MKC6xH40Nt6KSx4hXgNuKQjv0khD
         2/CHOmwF2Mvb11j2nnW5J/IJtTK0y2xug6Lwj40HoCnqI377P3SwNdzy6nAA66nESumY
         YheAOcTe8w1sTscqsxCFReMaIP1bmyF3RmH1E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=ex70dGEef5Ctoy83Pz7cxdcGJqsgvDVsEg6q5HLmBIU=;
        b=huGpJH42WAR9yzzUo/ZGbhdlWE8p8fTHPB2zOUNWka38zDof1MFmpu4JEu7wYB7PIq
         DNzFj7BNpw8b3IzSW4i/HKW2tqXNIB+BBPw5jqiYiVwIyhTzHrZNlR8AsnCoQ0OhBOSJ
         Ev3VhbVcGGAD4BSJMKAgPKmRF1svA4gfD59LYPQg2ngqOPLfMDJ6nhe3qUdS2XnRoTEQ
         wCDr19DkQz38w3nTPwaKsHm7Use1DdauRYFXCTFMnRPlZufuWvVnLtiko5Cpfj9p8WS2
         uBGGuPky+Ol48HkKEBKvDaWebZqJyjg5Xfy7392XPrfoFbXmmQnG/4DwOeJoA80Epm0p
         onIw==
X-Gm-Message-State: AOAM5324saFdtnSC3h0z5D8Srlpkui8brjFrOwEuXuFZ+Qh3wHkuNZRo
        A4dl2XFNhWXfq3J+W2YAYnPPJA==
X-Google-Smtp-Source: ABdhPJzoYlG4xXAoe5ctsVaf9MrA71YBJV7gjVD0ww3RX+RbUjRzGRxNW4F/Va98FlRsizESGYadwA==
X-Received: by 2002:a05:6512:128b:: with SMTP id u11mr40863lfs.528.1634742710000;
        Wed, 20 Oct 2021 08:11:50 -0700 (PDT)
Received: from cloudflare.com (2a01-110f-480d-6f00-ff34-bf12-0ef2-5071.aa.ipv6.supernova.orange.pl. [2a01:110f:480d:6f00:ff34:bf12:ef2:5071])
        by smtp.gmail.com with ESMTPSA id m27sm212122lfo.48.2021.10.20.08.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 08:11:49 -0700 (PDT)
References: <20211011191647.418704-1-john.fastabend@gmail.com>
 <20211011191647.418704-2-john.fastabend@gmail.com>
 <87tuhdfpq4.fsf@cloudflare.com>
 <616fa9127fa63_340c7208ef@john-XPS-13-9370.notmuch>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        joamaki@gmail.com, xiyou.wangcong@gmail.com
Subject: Re: [PATCH bpf 1/4] bpf, sockmap: Remove unhash handler for BPF
 sockmap usage
In-reply-to: <616fa9127fa63_340c7208ef@john-XPS-13-9370.notmuch>
Date:   Wed, 20 Oct 2021 17:11:49 +0200
Message-ID: <87pmrzg28a.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 07:28 AM CEST, John Fastabend wrote:
> Jakub Sitnicki wrote:
>> On Mon, Oct 11, 2021 at 09:16 PM CEST, John Fastabend wrote:
>> > We do not need to handle unhash from BPF side we can simply wait for the
>> > close to happen. The original concern was a socket could transition from
>> > ESTABLISHED state to a new state while the BPF hook was still attached.
>> > But, we convinced ourself this is no longer possible and we also
>> > improved BPF sockmap to handle listen sockets so this is no longer a
>> > problem.
>> >
>> > More importantly though there are cases where unhash is called when data is
>> > in the receive queue. The BPF unhash logic will flush this data which is
>> > wrong. To be correct it should keep the data in the receive queue and allow
>> > a receiving application to continue reading the data. This may happen when
>> > tcp_abort is received for example. Instead of complicating the logic in
>> > unhash simply moving all this to tcp_close hook solves this.
>> >
>> > Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
>> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
>> > ---
>>
>> Doesn't this open the possibility of having a TCP_CLOSE socket in
>> sockmap if I disconnect it, that is call connect(AF_UNSPEC), instead of
>> close it?
>
> Correct it means we may have TCP_CLOSE socket in the map. I'm not
> seeing any problem with this though. A send on the socket would
> fail the sk_state checks in the send hooks. (tcp.c:1245). Receiving
> from the TCP stack would fail with normal TCP stack checks.
>
> Maybe we want a check on redirect into ingress if the sock is in
> ESTABLISHED state as well? I might push that in its own patch
> though it seems related, but I think we should have that there
> regardless of this patch.
>
> Did you happen to see any issues on the sock_map side for close case?
> It looks good to me.

OK, I didn't understand if that was an intended change or not.

If we're considering allowing TCP sockets in TCP_CLOSE state in sockmap,
a few things come to mind:

1) We can't insert TCP_CLOSE sockets today. sock_map_sk_state_allowed()
   won't allow it. However, with this change we will be able to have a
   TCP_CLOSE socket in sockmap by disconnecting it. If so, perhaps
   inserting TCP sockets in TCP_CLOSE state should be allowed for
   consistency.

2) Checks in bpf_sk_lookup_assign() helper need adjusting. Only TCP
   sockets in TCP_LISTEN state make a valid choice (and UDP sockets in
   TCP_CLOSE state). Today we rely on the fact there that you can't
   insert a TCP_CLOSE socket.

3) Checks in sk_select_reuseport() helper need adjusting as well. It's a
   similar same case as with bpf_sk_lookup_assign() (with a slight
   difference that reuseport allows dispatching to connected UDP
   sockets).

4) Don't know exactly how checks in sockmap redirect helpers would need
   to be tweaked. I recall that it can't be just TCP_ESTABLISHED state
   that's allowed due to a short window of opportunity that opens up
   when we transition from TCP_SYN_SENT to TCP_ESTABLISHED.
   BPF_SOCK_OPS_STATE_CB callback happens just before the state is
   switched to TCP_ESTABLISHED.

   TCP_CLOSE socket sure doesn't make sense as a redirect target. Would
   be nice to get an error from the redirect helper. If I understand
   correctly, if the TCP stack drops the packet after BPF verdict has
   selected a socket, only the socket owner will know about by reading
   the error queue.

   OTOH, redirecting to a TCP_CLOSE_WAIT socket doesn't make sense
   either, but we don't seem to filter it out today, so the helper is
   not airtight.

All in all, sounds like an API change when it comes to corner cases, in
addition to being a fix for the receive queue flush issue which you
explained in the patch description. If possible, would push it through
bpf-next.
