Return-Path: <netdev+bounces-9650-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3883872A1BE
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:00:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 390381C210DF
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:00:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6D5020992;
	Fri,  9 Jun 2023 18:00:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C511C19BA3
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 18:00:04 +0000 (UTC)
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A3DD8;
	Fri,  9 Jun 2023 11:00:02 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 98e67ed59e1d1-256c8bed212so746635a91.3;
        Fri, 09 Jun 2023 11:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686333601; x=1688925601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SNb1MMHKODE+W69ko8eJiIRbDLaj/HDstcAoEpqfK+Q=;
        b=dg0V5yQi2bkckFqDvdwYht29KbuZk08RXcEsyF2X3Ha58HuE6aUhmdK6vxDq5PmFHl
         aDA4tDHvPzey4FIRZ/12YgWXj/flmLIt/t2++bNafoKmxtK+jcd7l60AQR+wsACNlBB4
         ZywHGyd3VN2XVQHnp/mR1rdyU0JdhH87vZX3FuzhHWkRsMJtezV6nk7SurWCAEMJ6OGa
         DONYUebJM8W/NcSsZPG9ptDaSv6aykWe8wG0B1YHcVOb3wsXLoDAAwylJb5+PJVUDfhV
         OiflbFSY50YSygvNqe5eRbK2VWsQS9LrD1WzPnDXQjPWIEVXoAocXScOKhsb0z52oXNc
         bgzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686333601; x=1688925601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SNb1MMHKODE+W69ko8eJiIRbDLaj/HDstcAoEpqfK+Q=;
        b=c/Px3VNJqnqNz1dmqgjynRytpnWsBJCatnO/kr+x3F/o/g4xSccA9JLTOfY/vni0se
         cdDq3wpHarHQZa854bnreqJSQFHybygd8BrEqqsFuA3U7YBNr1JGx4z3erPWGeu2nGPD
         q5iB+0zUJCJFRXv5hA14PxT1xgDN7RIz64POM3P1Mo1mKULQMZT3iJOZVD33vK/loCb2
         uI6BG78HXRo6e/6fvq8C2EfGLzP3iDknw+eZB3lUoHHDv+jXMb6s/4kSNvW7vslNmmU4
         V30blwobub1wpoy8v+1ZcSlQePhsMydfXSSckuhq3Rp+5Omor/9p49ZeXIL/5XLFhV4u
         1eig==
X-Gm-Message-State: AC+VfDxNQZx5Y4cgEBHLr2wDhLlIc3d4PBn5L9hMPNmo/NGswr5XDdqA
	raKPfn6gEIbJV4WUhSgPzs6hTSxFYIkjW+xsH6Xigkbk
X-Google-Smtp-Source: ACHHUZ4ILQUUCDhZ+t/b40Kl1SIxbljXOFMAD4tuRk40FkFxU8WGqfZZsMJuvBXR1UXt/At+05jD15Mrbgd6UEPJhi4=
X-Received: by 2002:a17:90a:6309:b0:259:5494:db4a with SMTP id
 e9-20020a17090a630900b002595494db4amr1460435pjj.30.1686333601370; Fri, 09 Jun
 2023 11:00:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601112839.13799-1-dinghui@sangfor.com.cn>
 <135a45b2c388fbaf9db4620cb01b95230709b9ac.camel@gmail.com>
 <eed0cbf7-ff12-057e-e133-0ddf5e98ef68@sangfor.com.cn> <6110cf9f-c10e-4b9b-934d-8d202b7f5794@lunn.ch>
 <f7e23fe6-4d30-ef1b-a431-3ef6ec6f77ba@sangfor.com.cn> <6e28cea9-d615-449d-9c68-aa155efc8444@lunn.ch>
 <CAKgT0UdyykQL-BidjaNpjX99FwJTxET51U29q4_CDqmABUuVbw@mail.gmail.com>
 <ece228a3-5c31-4390-b6ba-ec3f2b6c5dcb@lunn.ch> <CAKgT0Uf+XaKCFgBRTn-viVsKkNE7piAuDpht=efixsAV=3JdFQ@mail.gmail.com>
 <44905acd-3ac4-cfe5-5e91-d182c1959407@sangfor.com.cn> <20230602225519.66c2c987@kernel.org>
 <5f0f2bab-ae36-8b13-2c6d-c69c6ff4a43f@sangfor.com.cn> <20230604104718.4bf45faf@kernel.org>
 <f6ad6281-df30-93cf-d057-5841b8c1e2e6@sangfor.com.cn> <20230605113915.4258af7f@kernel.org>
 <034f5393-e519-1e8d-af76-ae29677a1bf5@sangfor.com.cn> <CAKgT0UdX7cc-LVFowFrY7mSZMvN0xc+w+oH16GNrduLY-AddSA@mail.gmail.com>
 <9c1fecc1-7d17-c039-6bfa-c63be6fcf013@sangfor.com.cn> <20230609101301.39fcb12b@kernel.org>
In-Reply-To: <20230609101301.39fcb12b@kernel.org>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Fri, 9 Jun 2023 10:59:25 -0700
Message-ID: <CAKgT0UeePd_+UwpGTT_v7nacf=yLoravtEZ2-gN4dpeWC5AsBg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ethtool: Fix out-of-bounds copy to user
To: Jakub Kicinski <kuba@kernel.org>
Cc: Ding Hui <dinghui@sangfor.com.cn>, Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net, 
	edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pengdonglin@sangfor.com.cn, 
	huangcun@sangfor.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 9, 2023 at 10:13=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Fri, 9 Jun 2023 23:25:34 +0800 Ding Hui wrote:
> > drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c: .get_sset_count  =
       =3D nfp_net_get_sset_count,
> > drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c: .get_sset_count  =
       =3D nfp_port_get_sset_count,
>
> Not sure if your research is accurate, NFP does not change the number
> of stats. The number depends on the device and the FW loaded, but those
> are constant during a lifetime of a netdevice.

Yeah, the value doesn't need to be a constant, it just need to be constant.

So for example in the ixgbe driver I believe we were using the upper
limits on the Tx and Rx queues which last I recall are stored in the
netdev itself.

