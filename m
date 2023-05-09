Return-Path: <netdev+bounces-1241-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0D7A6FCD94
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 20:18:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF9EC2812FB
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 18:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 197491950E;
	Tue,  9 May 2023 18:17:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EBB17FE0
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 18:17:57 +0000 (UTC)
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1290F1704
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 11:17:54 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id d75a77b69052e-3f38a9918d1so226091cf.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 11:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683656273; x=1686248273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S2UHCATH3G4CuSJf4Vt2XimiowlnQCvyva4J0Y6pMkg=;
        b=Mli6sJjznQpwgkxl03KMv9Ha9Q0uVZi6usPfIE7bV5rhYWG3rMpH/tXFlJYEQAtrPe
         C8cQFSATIeyaRKBBearzQRWEPXqK4RTh2/pbm/3KotJawrCfoQAMmqG6KHFGv0+LInVD
         xe2zW+twGzSmkzZHHYOFM1isS8rlNC90pLpUbUTUQeMewuWnwYvdzuDokXbe4dHMx/Ft
         QRR4TS0bsiIz2PJzZtMS0BqZJuILhC++3fY+TwB5CHWXhg6KMfPMzKGe55CFAOY+VZT9
         L1AHCrAVtuGUJ+NyEGBiFau844G7zH2uAbHNSHYGDfSFROX3VTT1dBqC6uhn3hbpyNxi
         ZDbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683656273; x=1686248273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S2UHCATH3G4CuSJf4Vt2XimiowlnQCvyva4J0Y6pMkg=;
        b=UGJ8tHeurcf9ePIHbE3MPPleUztMC0R3yM2xQkywmYPNpkABoFH5Rn5BPc4SBeRdve
         n15CxIF1ttYS1yMGUhympH1VZf5CMojuv8UDFyuMI9MKO50P+trZsbeWIKqWJfdhdNQ4
         CVmnnMyU9YhUGZRaVf8Ih+DBWm6WRxb8KnyEtkgOoDpF1QJcGDmcmZoWb7E3hxICT1tf
         ApT9yD05qLF05v2UyUPkkpy3TINWaacCQdDoX5I80j31/Vn1KQAkZj1QGchslbk2LChQ
         m6Ty6O0heoOUKK5QnMoxEdT+7gyBpqNCQWE4uGFvdv9WdqmKcJHwiaOsPgfkfmbPC92k
         cCMg==
X-Gm-Message-State: AC+VfDwO1m1EBWubmx9flfK9JQusIJIPRb31novlUFsWhAOJ8LCfzyA/
	UrnQ4O/4bm5/VfTB+ts4F8cZmakRKAM+AffPjDlpLg==
X-Google-Smtp-Source: ACHHUZ7G3A1pxETvCDMCgi5l0cfgkN5QkyBZAAL1qT1lH27vzhUsZzS/gxx89nyDdD3eGuZO5abz0LGlDhqNrNGqX24=
X-Received: by 2002:a05:622a:cb:b0:3e0:c2dd:fd29 with SMTP id
 p11-20020a05622a00cb00b003e0c2ddfd29mr42041qtw.4.1683656273106; Tue, 09 May
 2023 11:17:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230508020801.10702-1-cathy.zhang@intel.com> <20230508020801.10702-2-cathy.zhang@intel.com>
 <20230509171910.yka3hucbwfnnq5fq@google.com> <DM6PR11MB41078CDC3B97ED88AF71DEBFDC769@DM6PR11MB4107.namprd11.prod.outlook.com>
In-Reply-To: <DM6PR11MB41078CDC3B97ED88AF71DEBFDC769@DM6PR11MB4107.namprd11.prod.outlook.com>
From: Shakeel Butt <shakeelb@google.com>
Date: Tue, 9 May 2023 11:17:42 -0700
Message-ID: <CALvZod7njXsc0JDHxxi_+0c=owNwC6m1g_FieRfY4XkfuTmo1A@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
To: "Chen, Tim C" <tim.c.chen@intel.com>
Cc: "Zhang, Cathy" <cathy.zhang@intel.com>, "edumazet@google.com" <edumazet@google.com>, 
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>, 
	"pabeni@redhat.com" <pabeni@redhat.com>, "Brandeburg, Jesse" <jesse.brandeburg@intel.com>, 
	"Srinivas, Suresh" <suresh.srinivas@intel.com>, "You, Lizhen" <lizhen.you@intel.com>, 
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 9, 2023 at 11:04=E2=80=AFAM Chen, Tim C <tim.c.chen@intel.com> =
wrote:
>
> >>
> >> Run memcached with memtier_benchamrk to verify the optimization fix. 8
> >> server-client pairs are created with bridge network on localhost,
> >> server and client of the same pair share 28 logical CPUs.
> >>
> > >Results (Average for 5 run)
> > >RPS (with/without patch)     +2.07x
> > >
>
> >Do you have regression data from any production workload? Please keep in=
 mind that many times we (MM subsystem) accepts the regressions of microben=
chmarks over complicated optimizations. So, if there is a real production r=
egression, please be very explicit about it.
>
> Though memcached is actually used by people in production. So this isn't =
an unrealistic scenario.
>

Yes, memcached is used in production but I am not sure anyone runs 8
pairs of server and client on the same machine for production
workload. Anyways, we can discuss, if needed, about the practicality
of the benchmark after we have some impactful memcg optimizations.

> Tim

