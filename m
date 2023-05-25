Return-Path: <netdev+bounces-5276-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CEFB71084B
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 11:08:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52CE4281511
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 09:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 534FAD516;
	Thu, 25 May 2023 09:08:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEBB2CAB
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:08:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD926195
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 02:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685005682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6WwAh9efRQwhFEyM9VU1DiBGgZp979/2Wr6u+IJz1Cc=;
	b=KGXPwWKoQlf5odOQUy4a0zCUlF899mwWCZIEAx1IkqiHTLstdNrbMlTOb7FzjL4XIuk0FK
	jkKo8KNMSR4MgdtDLDd3aAvQGmcYlsylNdXMPcuXIoFhLjrr1SceTP9WTH+uDxlCXG9BTa
	LNRia6SktFM3wXYmCRr9QxkgUa9pf7g=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-ms_wXdkwPxmHA92wRpF0hw-1; Thu, 25 May 2023 05:08:01 -0400
X-MC-Unique: ms_wXdkwPxmHA92wRpF0hw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f50aa22cd2so2392035e9.1
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 02:08:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685005680; x=1687597680;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6WwAh9efRQwhFEyM9VU1DiBGgZp979/2Wr6u+IJz1Cc=;
        b=drncZ/AozYMLEGuTfDZ7HEkZOyUw8WBzSB3QecIREuJfkf4PxL/Vj5gfNWoqjzJsuc
         1DvbAM+p+85jpKknB/pBKTFeqlg1fuTKpmYI9VfN+mKt48bUcRVY24EZs5DR/k1rKQBM
         kNK8xuS9MnkabpNxTUu5Kt0eg7jMpbO+cPqK1bmmCXVywi4fuXrCO404u6jTwBnO9FOp
         CI1BD6d0hmzBmuAUjm8r+OVcnBkZmaQajsw7wOEKBnwBdS3wq132I8aIUMN15nqE/hrk
         mh73D07STNrSWxCOlkV15yfaFFU+iZWpP7ByDqM3jIUGaTbN823BP7muWW3ptRZPzIRz
         u05g==
X-Gm-Message-State: AC+VfDxfnnGshHzgBZ8Ts19Mi3C7h/dqnG04Q/BsyMhbkf95j56NMS6+
	V6+iub9beDVlfAJFVlLaGGMsu7ejQJr35yBHqbPZvM7doSd20KrA683tSIO3UVEL5hFvJqtvP8E
	wLax8JvNAWs1kpLvos8nYRC1N
X-Received: by 2002:a7b:cd07:0:b0:3f1:93c2:4df7 with SMTP id f7-20020a7bcd07000000b003f193c24df7mr1820114wmj.5.1685005680329;
        Thu, 25 May 2023 02:08:00 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7VLREfVW+AzWj+IROYw8A4Ui4eVr18eKssqhqm98Iw/1jx1C1ZkUaQzZXl6wwgUY1Yb/ypMA==
X-Received: by 2002:a7b:cd07:0:b0:3f1:93c2:4df7 with SMTP id f7-20020a7bcd07000000b003f193c24df7mr1820094wmj.5.1685005680060;
        Thu, 25 May 2023 02:08:00 -0700 (PDT)
Received: from debian (2a01cb058918ce004b671d3f9a8df89e.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:4b67:1d3f:9a8d:f89e])
        by smtp.gmail.com with ESMTPSA id m23-20020a7bca57000000b003f5ffba9ae1sm1400286wml.24.2023.05.25.02.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 02:07:59 -0700 (PDT)
Date: Thu, 25 May 2023 11:07:57 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <ZG8lbabbUTko/ZpF@debian>
References: <20230525110037.2b532b83@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525110037.2b532b83@canb.auug.org.au>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 11:00:37AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in:
> 
>   net/ipv4/raw.c
> 
> between commit:
> 
>   3632679d9e4f ("ipv{4,6}/raw: fix output xfrm lookup wrt protocol")
> 
> from the net tree and commit:
> 
>   c85be08fc4fa ("raw: Stop using RTO_ONLINK.")
> 
> from the net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
> 
> -- 
> Cheers,
> Stephen Rothwell
> 
> diff --cc net/ipv4/raw.c
> index eadf1c9ef7e4,8b7b5c842bdd..000000000000
> --- a/net/ipv4/raw.c
> +++ b/net/ipv4/raw.c
> @@@ -600,9 -596,8 +599,8 @@@ static int raw_sendmsg(struct sock *sk
>   		}
>   	}
>   
> - 	flowi4_init_output(&fl4, ipc.oif, ipc.sockc.mark, tos,
> - 			   RT_SCOPE_UNIVERSE,
> + 	flowi4_init_output(&fl4, ipc.oif, ipc.sockc.mark, tos, scope,
>  -			   hdrincl ? IPPROTO_RAW : sk->sk_protocol,
>  +			   hdrincl ? ipc.protocol : sk->sk_protocol,
>   			   inet_sk_flowi_flags(sk) |
>   			    (hdrincl ? FLOWI_FLAG_KNOWN_NH : 0),
>   			   daddr, saddr, 0, 0, sk->sk_uid);

Looks good. Thanks!


