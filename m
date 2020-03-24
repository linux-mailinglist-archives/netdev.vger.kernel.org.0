Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5154B191359
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgCXOg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 10:36:27 -0400
Received: from mail-eopbgr30060.outbound.protection.outlook.com ([40.107.3.60]:12341
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727363AbgCXOg0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 10:36:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNOhK5/5DytWTWx4JkCVTMHcmboLjSjsIma/7ftjcQUcYz6arM+62rZW/m/IG51jBREdvvi0/VXtXiS8dygj1mLizjJJ5Q93r1XWBQCXYCo6pSdDE3b7teMy79rPmtI95rqueSEGC+N+n11lvEaiy+KIaZQAOANQ5BCR1luO/ZIY8/YTOFGlFhEBe/6Trydpj/4g+su6uoTnPk2MBqFoyB2e2uHoGnTBejQRgcwAG+UqVan8vfnZTTymIOls3bdViDF18L0qhuia21sjkaXJDMskls2YUKBNtnKOpg/iIHrp7cmfWhSFhHsDCQRl7c6OFWl3VGxcu837NdBuXtb9gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxzm8LEuoXJoFRkphmFy89XplEsvbX+d+ax1JY4meS4=;
 b=OCWAEQVdehLrSbcbJCBJZNKItf+mdfOIWkKVm6PaXLuK8kqRCZvjG4QTcjxDHbwBgWX9GYYNIvxwzD3q1tR07fZOcho0EVVTAyIQCYevSzJvHyDii3FlZxBM5VRPgwSF4ZmDbgh6QFklm43fZSWCqWjbK/+2dfvc8IKwXSnS/ZNHOC9Kp5DIj7cG4DHaqexL2QUpDtuX2Mi0UkANjGZkppHMI0fQ9sf/iQuIHdmFO3hD83oAwcX2BdyPy0rxE+Jb91cAokmH/Pqosc48VwYq1bcWlNC2+Ig/zjSbzhKyHnydLRD2F+qX7FZx/xHSINYMbW8wQNfvXHTLfmZDxaYbGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxzm8LEuoXJoFRkphmFy89XplEsvbX+d+ax1JY4meS4=;
 b=iues4TNBkIYYPFzOs2jtF51Nw6AqLchReFeJvGCqjzk/16GTVIltxZXEsXbo7Ddgwqhq0EJNgZaegBonbuQ6m8YtEKzSsP+a6et633gI1JqXRr7+rhbnJy7okMTJbSK6fo+3C/Lx0+TU5AqNZym7j38ybmanNVCLH2nafNsTrJ8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
Received: from VI1PR05MB3359.eurprd05.prod.outlook.com (10.170.238.32) by
 VI1PR05MB5296.eurprd05.prod.outlook.com (20.178.9.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Tue, 24 Mar 2020 14:36:20 +0000
Received: from VI1PR05MB3359.eurprd05.prod.outlook.com
 ([fe80::cd2b:cd2:d07a:1db4]) by VI1PR05MB3359.eurprd05.prod.outlook.com
 ([fe80::cd2b:cd2:d07a:1db4%7]) with mapi id 15.20.2835.021; Tue, 24 Mar 2020
 14:36:20 +0000
References: <1585007097-28475-1-git-send-email-wenxu@ucloud.cn> <1585007097-28475-3-git-send-email-wenxu@ucloud.cn> <vbfimiudklj.fsf@mellanox.com> <d6e75961-1098-1dc4-b1ea-fa733aeb37c0@ucloud.cn>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     Vlad Buslov <vladbu@mellanox.com>, saeedm@mellanox.com,
        paulb@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v5 2/2] net/mlx5e: add mlx5e_rep_indr_setup_ft_cb support
In-reply-to: <d6e75961-1098-1dc4-b1ea-fa733aeb37c0@ucloud.cn>
Date:   Tue, 24 Mar 2020 16:36:16 +0200
Message-ID: <vbfh7ydes67.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: PR2P264CA0007.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::19)
 To VI1PR05MB3359.eurprd05.prod.outlook.com (2603:10a6:802:1c::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by PR2P264CA0007.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15 via Frontend Transport; Tue, 24 Mar 2020 14:36:19 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1445e197-188f-498b-f0a3-08d7d000b822
X-MS-TrafficTypeDiagnostic: VI1PR05MB5296:|VI1PR05MB5296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB529613C1026F840C39124020ADF10@VI1PR05MB5296.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(4326008)(6916009)(66556008)(6666004)(66476007)(6486002)(36756003)(2906002)(16526019)(316002)(186003)(66946007)(478600001)(8676002)(7696005)(8936002)(956004)(86362001)(5660300002)(2616005)(26005)(81166006)(52116002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5296;H:VI1PR05MB3359.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EnuF9MuJ0ra+hbVtlczWGlT28BECl6Urs4xKCzQwqSCFBBpc3Op/40dF/dpaJMN+OS7rR8bTxRvnYo6z2ozSFNpTjjfxPun2eqETi/bWwocrUjqKflZ7r3FD7Qq6Zvcum61Ap/ysbyOBDzRJTG6lBzsPRC7lNhqciqC2SW9j+H+dY7wCOuROlaSbuQBBLzqz72L2yrkwS6bVMqCTV79JDwdl3tjtTX0HL6ZAZmgGmkXU16tomdO7L3MGv5B9aHpdtdboyLl6Mx9KI6Iv7TkuDNIr3AH5iZ3IYeoZYs3TG4VVk4rYb+v9ZEy0C0jAlOR8POPEG11qgr76sDjji7gckr0vFgFwCtznCglHMsvKxvEfmvZ0P5vRjt1kHCjUvNwg3uXTSXr1Asa5S2ekjrFBYbgw30gU3J/KVEX32uIVeZ9xRs6ZwaCrQajqpYoF47ea
X-MS-Exchange-AntiSpam-MessageData: my9fRcCY5+GukRKKrbEJH71u9ZBjItIw32gguxT5ZlRqCvnBth3U9tCRHi/XGUJj06aspHVCmBeHIWBIQamS/g8io2du5ADxhXN4++XKJHFrTGlr/eqJoLVNntxBc6mReGnuJt6Ef8oinnByrabfcw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1445e197-188f-498b-f0a3-08d7d000b822
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 14:36:20.6068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pqa2Lk8bnMIJGc68MW40dTY2UJrZjT9M5y1s0w0wWDmnNHwj10ZXMSSQdf9P3Dg7gYqkRLYg6nPmY7cDWNCOeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5296
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 24 Mar 2020 at 14:49, wenxu <wenxu@ucloud.cn> wrote:
> =E5=9C=A8 2020/3/24 20:05, Vlad Buslov =E5=86=99=E9=81=93:
>> On Tue 24 Mar 2020 at 01:44, wenxu@ucloud.cn wrote:
>>> From: wenxu <wenxu@ucloud.cn>
>>>
>>> Add mlx5e_rep_indr_setup_ft_cb to support indr block setup
>>> in FT mode.
>>>
>>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>>> ---
>>> v5: no change
>>>
>>>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 52 +++++++++++++++=
+++++++++
>>>   1 file changed, 52 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_rep.c
>>> index 057f5f9..30c81c3 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
>>> @@ -732,6 +732,55 @@ static int mlx5e_rep_indr_setup_tc_cb(enum tc_setu=
p_type type,
>>>   	}
>>>   }
>>>
>>> +static int mlx5e_rep_indr_setup_ft_cb(enum tc_setup_type type,
>>> +				      void *type_data, void *indr_priv)
>>> +{
>>> +	struct mlx5e_rep_indr_block_priv *priv =3D indr_priv;
>>> +	struct flow_cls_offload *f =3D type_data;
>>> +	struct flow_cls_offload tmp;
>>> +	struct mlx5e_priv *mpriv;
>>> +	struct mlx5_eswitch *esw;
>>> +	unsigned long flags;
>>> +	int err;
>>> +
>>> +	mpriv =3D netdev_priv(priv->rpriv->netdev);
>>> +	esw =3D mpriv->mdev->priv.eswitch;
>>> +
>>> +	flags =3D MLX5_TC_FLAG(EGRESS) |
>>> +		MLX5_TC_FLAG(ESW_OFFLOAD) |
>>> +		MLX5_TC_FLAG(FT_OFFLOAD);
>>> +
>>> +	switch (type) {
>>> +	case TC_SETUP_CLSFLOWER:
>>> +		memcpy(&tmp, f, sizeof(*f));
>>> +
>>> +		if (!mlx5_esw_chains_prios_supported(esw))
>>> +			return -EOPNOTSUPP;
>>> +
>>> +		/* Re-use tc offload path by moving the ft flow to the
>>> +		 * reserved ft chain.
>>> +		 *
>>> +		 * FT offload can use prio range [0, INT_MAX], so we normalize
>>> +		 * it to range [1, mlx5_esw_chains_get_prio_range(esw)]
>>> +		 * as with tc, where prio 0 isn't supported.
>>> +		 *
>>> +		 * We only support chain 0 of FT offload.
>>> +		 */
>>> +		if (tmp.common.prio >=3D mlx5_esw_chains_get_prio_range(esw))
>>> +			return -EOPNOTSUPP;
>>> +		if (tmp.common.chain_index !=3D 0)
>>> +			return -EOPNOTSUPP;
>>> +
>>> +		tmp.common.chain_index =3D mlx5_esw_chains_get_ft_chain(esw);
>>> +		tmp.common.prio++;
>>> +		err =3D mlx5e_rep_indr_offload(priv->netdev, &tmp, priv, flags);
>>> +		memcpy(&f->stats, &tmp.stats, sizeof(f->stats));
>> Why do you need to create temporary copy of flow_cls_offload struct and
>> then copy parts of tmp back to the original? Again, this info should
>> probably be in the commit message.
>
> This FT mode using the specficed chain_index which changed by driver adnd
>
> using only in driver. It will move the flow table rules to their steering
> domain.
>
> This scenario just follow the mlx5e_rep_setup_ft_cb which did offload in =
FT
> mode.
>
> So it's an old scenario, Is it necessary to add to the commit message?

Well, without knowing the reasoning it is hard to understand if the
original scenario is applicable in this case.

>
>>
>>> +		return err;
>>> +	default:
>>> +		return -EOPNOTSUPP;
>>> +	}
>>> +}
>>> +
>>>   static void mlx5e_rep_indr_block_unbind(void *cb_priv)
>>>   {
>>>   	struct mlx5e_rep_indr_block_priv *indr_priv =3D cb_priv;
>>> @@ -809,6 +858,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netd=
ev, void *cb_priv,
>>>   	case TC_SETUP_BLOCK:
>>>   		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
>>>   						  mlx5e_rep_indr_setup_tc_cb);
>>> +	case TC_SETUP_FT:
>>> +		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
>>> +						  mlx5e_rep_indr_setup_ft_cb);
>>>   	default:
>>>   		return -EOPNOTSUPP;
>>>   	}

