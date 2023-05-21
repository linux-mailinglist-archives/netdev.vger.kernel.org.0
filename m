Return-Path: <netdev+bounces-4128-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A45270B001
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 21:47:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D668E280E6A
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 19:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C47944F;
	Sun, 21 May 2023 19:47:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3D98F62
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 19:47:46 +0000 (UTC)
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCAAE3
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 12:47:44 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-64d2e8a842cso2081742b3a.3
        for <netdev@vger.kernel.org>; Sun, 21 May 2023 12:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684698464; x=1687290464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qauo7UvjHCNzW7xF95/Fjid5F5NqNvlTNoRh6Cr0xvE=;
        b=ic0zdYTKWeTa7dwGDBuNW/oAlonMB44KcAaFDaNfitxEs1fdUqzAxxvw8QDlmWBM3k
         nm/va09S3I3klR4/6aFlvgxSfdpndOlIZug/lPlmVuIIjt6Xp2l937O41cQWa2ArC7OC
         ChrLjYxK5F1+UMYthiBLfmvlF32vh5AHZmrABGNCNtWClZrAk6hCUnzA1LU48CBijoaF
         5nHnbjkDa6qMt6+0TZwMAUoVIMga7JiKy1hbJ9aW0bIAvEZQ961v2WIFhGYcdtbx2zSG
         CYkhwSO4nGtTizFd4nkYVs+VlNtp+aIHJu1xvKbtdRwcEVKe/fsOnlbD7yZKRdDxcFF9
         TItA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684698464; x=1687290464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qauo7UvjHCNzW7xF95/Fjid5F5NqNvlTNoRh6Cr0xvE=;
        b=kddKjWNNYVSLLl0PT3oYSaRv2H45Ov41bTNZcbGsvUtxz8+CsdvFmaSvIlvFdTiPel
         TYHNFxbisabp7i+BMk55+UNfO9z23zZySThK/snA51Op3KY5tH9/0lFquD27Y6FKIRGW
         RO9GG7I1ehWRfUR9Glt9bkAL/HvxIH6M4/iPQc+D+r/Zu6aS6chiKuuEtkkpikDjIoMe
         sgQaN56WmurX4I0Tvgl4q6Sif6FOEP60sYfeLXqJrQqzztX5uSgipHGrv6HJj53eDFxG
         LRQ+Ikl39OA6d7s495lhUYNpj/AEBrP976ml/4pcmyXT0qMIFk5rytuJCrkNXh0NmlRA
         HAVA==
X-Gm-Message-State: AC+VfDwYEHsPkyXoYqU1zFb3v7LDBktvTDTLXKAaMMqaICTikMO5KKpA
	dSj9/TCF19V13cLrl2BLW0efVA==
X-Google-Smtp-Source: ACHHUZ7ab/RKE8GZGfTHc61fsJFZYBGsLSD8Qfesm7qumSTJ20RjW6WC79BPUUmx4NhN1DKLfzUZsw==
X-Received: by 2002:a05:6a21:6811:b0:106:c9b7:c932 with SMTP id wr17-20020a056a21681100b00106c9b7c932mr3258503pzb.1.1684698464372;
        Sun, 21 May 2023 12:47:44 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id t2-20020aa79382000000b0064d1d8fd24asm2861549pfe.60.2023.05.21.12.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 May 2023 12:47:44 -0700 (PDT)
Date: Sun, 21 May 2023 12:47:41 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Ido Schimmel <idosch@idosch.org>
Cc: Vladimir Nikishkin <vladimir@nikishkin.pw>, dsahern@gmail.com,
 netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
 gnault@redhat.com, razor@blackwall.org, idosch@nvidia.com,
 liuhangbin@gmail.com, eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v5] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <20230521124741.3bb2904c@hermes.local>
In-Reply-To: <ZGpvrV4FGjBvqVjg@shredder>
References: <20230521054948.22753-1-vladimir@nikishkin.pw>
	<ZGpvrV4FGjBvqVjg@shredder>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, 21 May 2023 22:23:25 +0300
Ido Schimmel <idosch@idosch.org> wrote:

> +       if (tb[IFLA_VXLAN_LOCALBYPASS])
> +               print_bool(PRINT_ANY, "localbypass", "localbypass ",
> +                          rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]))

That will not work for non json case.  It will print localbypass whether it is set or not.
The third argument is a format string used in the print routine.

