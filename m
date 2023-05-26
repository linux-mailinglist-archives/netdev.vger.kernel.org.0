Return-Path: <netdev+bounces-5567-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B0147122A4
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:49:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40F5C2816CB
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:49:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36148D2FF;
	Fri, 26 May 2023 08:49:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE5FAD25
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:49:20 +0000 (UTC)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA92F119;
	Fri, 26 May 2023 01:49:17 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-307d20548adso248866f8f.0;
        Fri, 26 May 2023 01:49:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685090956; x=1687682956;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s4Sjrbm6d6EO6iQQ0zbM7JAHxdD9NnQEGIWbfdTn3q4=;
        b=kxgIC8qndyOU6bBu/akOD1HMJGDqlMOtFDUf9zvh9AZM9TVABXXL2+0tIWkKt1fxyZ
         lYBNooGA0eF5O+l3Y313YWx2f9JM/z1+M3/+BAOwy46EPzp+vNfqwKIFGEPTxFCNiYdB
         V63mS88EBcXZoC559mhAnRlbvF9zfyyJbWLH5CJxxTJDNseyi1SywddrokGGl2sOaIpK
         B9AxRL4cWMsxLCspdWxK1/W8ywpbyySVuCQ/MWxfU8sJ8s7y2yVlvEqGCOiUlXFSqW0q
         BGc+byNO39HcbPKooV6WoeFT4ce1FiJtKzTBcRktMx0J/76CTdZ1MRsggBcs8Dy5/R+L
         zM3A==
X-Gm-Message-State: AC+VfDyi1IZP6u9nGOoA+9q+CAm6cs09BP3rP28LtSSyvYrruXB0Jbpe
	2k2DXZ+hGkwWlFlLtflJOhk=
X-Google-Smtp-Source: ACHHUZ7zycneQMT5MV6N2pE69nG7qYgQwCpYDyX2JqqJ+e0B9ZF6lJoMXa9DIxgrYpSDUMuFvhezxA==
X-Received: by 2002:a05:6000:196b:b0:30a:b4e1:a89b with SMTP id da11-20020a056000196b00b0030ab4e1a89bmr731849wrb.67.1685090956051;
        Fri, 26 May 2023 01:49:16 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-005.fbsv.net. [2a03:2880:31ff:5::face:b00c])
        by smtp.gmail.com with ESMTPSA id y3-20020a5d4703000000b002f103ca90cdsm4338479wrq.101.2023.05.26.01.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 01:49:15 -0700 (PDT)
Date: Fri, 26 May 2023 01:49:10 -0700
From: Breno Leitao <leitao@debian.org>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: dsahern@kernel.org, Remi Denis-Courmont <courmisch@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexander Aring <alex.aring@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Mat Martineau <martineau@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>, leit@fb.com, axboe@kernel.dk,
	asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, dccp@vger.kernel.org,
	linux-wpan@vger.kernel.org, mptcp@lists.linux.dev,
	linux-sctp@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: ioctl: Use kernel memory on protocol
 ioctl callbacks
Message-ID: <ZHByhjt2xYf5xKAu@gmail.com>
References: <20230525125503.400797-1-leitao@debian.org>
 <CAF=yD-LHQNkgPb-R==53-2auVxkP9r=xqrz2A8oe61vkoDdWjg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF=yD-LHQNkgPb-R==53-2auVxkP9r=xqrz2A8oe61vkoDdWjg@mail.gmail.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 11:05:40AM -0400, Willem de Bruijn wrote:
> On Thu, May 25, 2023 at 8:55 AM Breno Leitao <leitao@debian.org> wrote:
> > @@ -1547,6 +1547,28 @@ int ip_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
> >         return ret;
> >  }
> >
> > +/* Execute if this ioctl is a special mroute ioctl */
> > +int ipmr_sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
> > +{
> > +       switch (cmd) {
> > +       /* These userspace buffers will be consumed by ipmr_ioctl() */
> > +       case SIOCGETVIFCNT: {
> > +               struct sioc_vif_req buffer;
> > +
> > +               return sock_ioctl_inout(sk, cmd, arg, &buffer,
> > +                                     sizeof(buffer));
> > +               }
> 
> More importantly, if we go down the path of demultiplexing in protocol
> independent code to call protocol specific handlers, then there there
> is no need to have them call protocol independent helpers like
> sock_ioct_inout again. Just call the protocol-specific ioctl handlers
> directly?

That is what I was expecting, but, the code is exactly the same and I
kept it in the generic section. This is what this code needs to do:

 * Copy X byte from userspace
 * sk->sk_prot->ioctl()
 * Copy X bytes back to userspace

I tried to keep the code generic enough that it could be reused.
I can definitely push the same code to two different protocols, if you
prefer, no strong opinion. 

