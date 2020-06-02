Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6AC1EB7BA
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 10:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgFBIzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 04:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbgFBIzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 04:55:16 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94E0C03E97D
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 01:55:15 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id z5so11987803ejb.3
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 01:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=UpZeVaraeAQCVNTZxXpOffz+FSPS8pHdNGnocyS2mhk=;
        b=IfTL60FvMGXj/A7fWRprxLo4myJSe/7osNvWnXdiUhVLmyrNXubAGMwIkVO9CPVnJa
         C0J6bji0V7H6sHXSlwvcr/L8YjnMrYhoZGXOqHzOOEWJfBsn/9BNRPCD255Y/YPiij1V
         vkPqMp6+ldS0xbEku1m5tfZw40rDl+vFsUCt4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=UpZeVaraeAQCVNTZxXpOffz+FSPS8pHdNGnocyS2mhk=;
        b=WWeJGBiCG1BMQUAcXp/g7rUBBuK3ztGKzpothOKC+1vyde/C76siqxo9cdqihkSKRI
         bZ+E0QNTEWriv/MtTlZMzEN09p8xMq9hBXOaX9OInDEza/aNd8OW83w0EcQg0YL/QdV7
         1zJEv4+uCzcPZI5Ob/8z/9oOkHrKJhur2CHZZ4nvZkwGi3AFkKpfm4pOPWT8zJheb8l9
         R1gxkjy88iGGUi680GX0lXJ+1uvZYzP03vcS5Vfs4bM98EQDTEZzPgpLiDm45Adr4zFo
         jOVRU5+zxzIYYH2nNWkpExPZnlAmfE7dRDsPRYjdOt8p7RahmmGUm6kRMVFo7LRxNd6+
         aVWQ==
X-Gm-Message-State: AOAM531YKV25Gdmu1DXMevwXzMaTD/KIQsEtPwJ9gXxo0d6ipGEWz0Go
        yu6hytw0Wwubahy7f9Yc/r/rQ31t8Uk=
X-Google-Smtp-Source: ABdhPJwJqxgwVu93QJg4CxBwG5J1Q0TEJ2Y32gJowtg7cF18HlBLAu2TrQXYuGRlXg4kMh8XqgxwhQ==
X-Received: by 2002:a17:906:934d:: with SMTP id p13mr23219841ejw.414.1591088113536;
        Tue, 02 Jun 2020 01:55:13 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id la5sm1347388ejb.94.2020.06.02.01.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 01:55:12 -0700 (PDT)
References: <159079336010.5745.8538518572099799848.stgit@john-Precision-5820-Tower> <159079361946.5745.605854335665044485.stgit@john-Precision-5820-Tower> <20200601165716.5a6fa76a@toad> <5ed51cae71d0d_3f612ade269e05b46e@john-XPS-13-9370.notmuch> <5ed523a8b7749_54cc2acde13425b85b@john-XPS-13-9370.notmuch>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        alexei.starovoitov@gmail.com, daniel@iogearbox.net
Subject: Re: [bpf-next PATCH 2/3] bpf: fix running sk_skb program types with ktls
In-reply-to: <5ed523a8b7749_54cc2acde13425b85b@john-XPS-13-9370.notmuch>
Date:   Tue, 02 Jun 2020 10:55:11 +0200
Message-ID: <87img93l00.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 01, 2020 at 05:50 PM CEST, John Fastabend wrote:
> John Fastabend wrote:
>> Jakub Sitnicki wrote:
>> > On Fri, 29 May 2020 16:06:59 -0700
>> > John Fastabend <john.fastabend@gmail.com> wrote:
>> >
>> > > KTLS uses a stream parser to collect TLS messages and send them to
>> > > the upper layer tls receive handler. This ensures the tls receiver
>> > > has a full TLS header to parse when it is run. However, when a
>> > > socket has BPF_SK_SKB_STREAM_VERDICT program attached before KTLS
>> > > is enabled we end up with two stream parsers running on the same
>> > > socket.
>> > >
>> > > The result is both try to run on the same socket. First the KTLS
>> > > stream parser runs and calls read_sock() which will tcp_read_sock
>> > > which in turn calls tcp_rcv_skb(). This dequeues the skb from the
>> > > sk_receive_queue. When this is done KTLS code then data_ready()
>> > > callback which because we stacked KTLS on top of the bpf stream
>> > > verdict program has been replaced with sk_psock_start_strp(). This
>> > > will in turn kick the stream parser again and eventually do the
>> > > same thing KTLS did above calling into tcp_rcv_skb() and dequeuing
>> > > a skb from the sk_receive_queue.
>> > >
>> > > At this point the data stream is broke. Part of the stream was
>> > > handled by the KTLS side some other bytes may have been handled
>> > > by the BPF side. Generally this results in either missing data
>> > > or more likely a "Bad Message" complaint from the kTLS receive
>> > > handler as the BPF program steals some bytes meant to be in a
>> > > TLS header and/or the TLS header length is no longer correct.
>> > >
>> > > We've already broke the idealized model where we can stack ULPs
>> > > in any order with generic callbacks on the TX side to handle this.
>> > > So in this patch we do the same thing but for RX side. We add
>> > > a sk_psock_strp_enabled() helper so TLS can learn a BPF verdict
>> > > program is running and add a tls_sw_has_ctx_rx() helper so BPF
>> > > side can learn there is a TLS ULP on the socket.
>> > >
>> > > Then on BPF side we omit calling our stream parser to avoid
>> > > breaking the data stream for the KTLS receiver. Then on the
>> > > KTLS side we call BPF_SK_SKB_STREAM_VERDICT once the KTLS
>> > > receiver is done with the packet but before it posts the
>> > > msg to userspace. This gives us symmetry between the TX and
>> > > RX halfs and IMO makes it usable again. On the TX side we
>> > > process packets in this order BPF -> TLS -> TCP and on
>> > > the receive side in the reverse order TCP -> TLS -> BPF.
>> > >
>> > > Discovered while testing OpenSSL 3.0 Alpha2.0 release.
>> > >
>> > > Fixes: d829e9c4112b5 ("tls: convert to generic sk_msg interface")
>> > > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
>> > > ---
>
> [...]
>
>> > > +static void sk_psock_tls_verdict_apply(struct sk_psock *psock,
>> > > +				       struct sk_buff *skb, int verdict)
>> > > +{
>> > > +	switch (verdict) {
>> > > +	case __SK_REDIRECT:
>> > > +		sk_psock_skb_redirect(psock, skb);
>> > > +		break;
>> > > +	case __SK_PASS:
>> > > +	case __SK_DROP:
>> >
>> > The two cases above need a "fallthrough;", right?
>>
>> Correct otherwise will get the "fallthrough" patch shortly after this
>> lands. Thanks I'll add it.
>>
>
> hmm actually I don't think we need 'fallthrough;' here when the
> case doesn't have statements,
>
>  switch (a) {
>  case 1:
>  case 2:
>  default:
>      break;
>  }
>
> seems OK to me. I don't have a preference though so feel free to
> correct me.

I misunderstood guidance in [0]. You're right, it seems too verbose to
annotate cases without statements. Didn't mean to nit-pick :-)

[0] https://www.kernel.org/doc/html/latest/process/deprecated.html#implicit-switch-case-fall-through
