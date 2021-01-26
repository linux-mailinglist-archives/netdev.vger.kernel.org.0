Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FF7304947
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731771AbhAZFcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730549AbhAZBcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 20:32:01 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on062d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe02::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88D6C0698C9
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 17:20:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oa//lL3aSjQ2Y4bKoABUqwdtgGDhMTEa0XZyj4g2LJeCAbiLf3L8O0ZA4Uri4/7nHZZ5nRPbxzxxSfdisZnf4PeTlXdwoqF9tpnM02NFduhJYPkTfRm+RgA2Rj5nlXvcaBGUAKM6xtA0vtdg8i7JeWWgTPkC8vDdhCH8FNQf53m1qAF4Lqqj9PAQ9raO9vlQ6zZ8s0Uo9DyQeB5XGq3u1uSb9/h6OC7U9nhM3pr7Zwvu+aQiEOHayxLrh+i92ObyzwGIEjuw0CfApsVbKeIyu77JIXpWADQ+nyosnE2EOiGHlAbvMom3yaA6rTompZbpuGXvIlR54kM+heOXVoh2BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nPqIyX0/z2K2AORVgGAfeuqkIZt9w8VEOcPTfjlrs5Q=;
 b=J31psl0uzX1ymrqzeOcalK1maboijati2t4J5dqS2x4gbXL5SuX7YtUkigHCJRhfNDx1xWRRts5+ETEpUTBASrCgrmYBb/kyrbiSiz11+rCVnrbV/xyv40jF0cwFNfHgMUn59hu/l0SL6tII+AR8Dfnth/fU1zNtD5u+9f0CB+PZKpWxSQbg9RoaXpzGXc8x2IzmLBWn9W6wUcjASKI8m+8NUVgTQQC+AueYeXm5giSsmF73Nhh6fUtFWmtYAxmS+/IfhC+3sqlxhtzSyIu9RfwFc/oVXX6nFfXiASXnDMobfk78uWDKJvGVT9HDiU0tEyIpvPv3xdsF/rhmmYyQaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nPqIyX0/z2K2AORVgGAfeuqkIZt9w8VEOcPTfjlrs5Q=;
 b=rkY0N+utJL+CRe3mVbvUQXRV/QoCm780wvhPY/MiYcNguXiKWSqBGPXFcv6oJu0YtNgyMbhvMeMNYc0UnPGeaE9cT2hdEu/kSYXPIHmrK9v6JcCIarlZxZJ2QRcjmdFGUhQTYvZlUwGQSIM9dNn6brcDs40xXGuvM7TsvfKpMtM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5344.eurprd04.prod.outlook.com (2603:10a6:803:4b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.17; Tue, 26 Jan
 2021 00:09:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%6]) with mapi id 15.20.3784.012; Tue, 26 Jan 2021
 00:09:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v3 2/8] taprio: Add support for frame preemption
 offload
Thread-Topic: [PATCH net-next v3 2/8] taprio: Add support for frame preemption
 offload
Thread-Index: AQHW8RBJQDX+89PKk0KRFCgmtnZ2gKo5DOAA
Date:   Tue, 26 Jan 2021 00:09:25 +0000
Message-ID: <20210126000924.jjkjruzmh5lgrkry@skbuf>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
 <20210122224453.4161729-3-vinicius.gomes@intel.com>
In-Reply-To: <20210122224453.4161729-3-vinicius.gomes@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 371aef25-1d65-457a-7436-08d8c18ea3f9
x-ms-traffictypediagnostic: VI1PR04MB5344:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5344806C60EA416BA47D0BB8E0BC0@VI1PR04MB5344.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 01bdiIqqAXQn1HFNYeoEDXbFhf4DUJwamcjEZmpWxttrK/nf2+qz2oUsiHw2UiSCYGIBzkBIbnyUDEJnolHJue/teqP6+mVGLX/ahtQPBonOUdZyCzhsOF7OEzEuxBy3UmlT7/4nj7pnB2IrX+02I0DeART1zGdqHgzGfMjVe5TTB7ir77JmqP51K9DinZ23FLTv/noB+PoJ5EVqcAazPAuuWC7PyOtSw4HTH6cdqaBmnUxOm7unYuarxujsax/KJRNVLUm1gCJoJYAQ1mcyUjF9PZnRUPgydKhzjQuHWHinc9RKIqzALc6aDen5sPsdIYbXbicTEpqnxc1tYikInMyrVPag9/ZLbO9FWdgSzIJoLpyr8+gClWAlBmyW+Bj+oILtMAsOTu8UrlinxAKtbQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(396003)(376002)(366004)(136003)(346002)(7416002)(91956017)(5660300002)(54906003)(66946007)(71200400001)(6486002)(66556008)(4326008)(66476007)(8676002)(64756008)(6916009)(66446008)(76116006)(1076003)(478600001)(316002)(44832011)(33716001)(6512007)(9686003)(6506007)(86362001)(8936002)(2906002)(26005)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?FMTuLeDFaSNpiHYMXBw7TW+s0wMKaaSj00/l3AD8WCb5nGNEEEvJFRANdKmj?=
 =?us-ascii?Q?CF392JcClIFk2ZQxRlRHy+XWUeozDVNxNz/VJryw+q1IL04bMeBsTNLODxMn?=
 =?us-ascii?Q?mMUlrhGKTsB/1oHIdVvoEJ42YAjDBDQ2sXAn23+Ep7/s4pZMjPhh8WjNYW61?=
 =?us-ascii?Q?OC+DK6pofWoJdNr3ULLLgXDeWnHq1GN84KskEYFMr1/3G796QZl4Y+bxAfEG?=
 =?us-ascii?Q?HlnP43goyK63VNd40qzt880oFK32/9nt77DJHTkNHrTPelfPG15tMzIHRM8t?=
 =?us-ascii?Q?JC7pDVyx/jBhYFE8Pxk6S2v5vzT10IBJ9KTYKm7ipMq+TdFmJZ49uMeyddun?=
 =?us-ascii?Q?UYZvAx6kOhwZeBCupPclW3/cptn5JCL0ZkgnaMqQCVJJUZS1vdp5+bUzpaSE?=
 =?us-ascii?Q?NNVAFCnnQynjCXL0CkKx8svDqTJEuz3tZ7pd8GDjHFnnPFHep58G2ipRtFM2?=
 =?us-ascii?Q?J3ZCNr7qevEQB+JZp2GP8dySHquACt7TYiIln/eF0Bfl1b5/RCIqzhF3glv2?=
 =?us-ascii?Q?m4U5FDwUa5ezjcfGxK6uTJCp9WdPhb33c9b7b+PzrWbXdTr/f6RExwhP2SKF?=
 =?us-ascii?Q?0htM1dnq4wdxxjyN/iDV13vpUyqJEOPw/YJ3sbL7STp20kdgq7pYnQ7LPeMi?=
 =?us-ascii?Q?Vc8j9cbtzscRzfOkBsMA62Mnp6YSqeTVHZnxRcpK7IlZazw2vxwDPlmaF+p2?=
 =?us-ascii?Q?O2Mjul7dBjXxdNbORrPD/aq6PNinJdVpYYvstCF1cEru49HA5dUg/nWarCC/?=
 =?us-ascii?Q?QIlZ0Y7Gu5duykMjTG8WoWMEEsYD72KRvOFOvLLghXWuw2TKJ9G2aicO3Rvg?=
 =?us-ascii?Q?GmOIneJYmNhS/XdC8ypev3g8oVQTf6AWjq1hdifxxCNYlKdYv2ebghOZVbWN?=
 =?us-ascii?Q?Io8SQU6U+BKPstH4D9IiusH8ewsZZqKBDHcgSlbLA5X+3JtLRJqJvrG5/tJY?=
 =?us-ascii?Q?lZKueKbCz+g34LD2x3KD5XOV289eVXIyXX60ceaOMIqCQJUAW1GqGAmBVLGT?=
 =?us-ascii?Q?eUKKfwNAiMTIoSSVquQ0bbTjPsjBx3ZGepyjEqu9YMbHbdd53OjeDAPi1/OS?=
 =?us-ascii?Q?sVGzR9xA?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <515465FA6579FD43972927240F724429@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 371aef25-1d65-457a-7436-08d8c18ea3f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2021 00:09:25.2446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Upl9sTEemdCw5e1nde5BCWx3L/FVs58P31MiEJh1aGETNCguqjSxJ3KBGEgyqRTPZTOggwwt6Ym3TGvcHquHyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5344
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 02:44:47PM -0800, Vinicius Costa Gomes wrote:
> +	/* It's valid to enable frame preemption without any kind of
> +	 * offloading being enabled, so keep it separated.
> +	 */
> +	if (tb[TCA_TAPRIO_ATTR_PREEMPT_TCS]) {
> +		u32 preempt =3D nla_get_u32(tb[TCA_TAPRIO_ATTR_PREEMPT_TCS]);
> +		struct tc_preempt_qopt_offload qopt =3D { };
> +
> +		if (preempt =3D=3D U32_MAX) {
> +			NL_SET_ERR_MSG(extack, "At least one queue must be not be preemptible=
");
> +			err =3D -EINVAL;
> +			goto free_sched;
> +		}
> +
> +		qopt.preemptible_queues =3D tc_map_to_queue_mask(dev, preempt);
> +
> +		err =3D dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_PREEMPT,
> +						    &qopt);
> +		if (err)
> +			goto free_sched;
> +
> +		q->preemptible_tcs =3D preempt;
> +	}
> +

First I'm interested in the means: why check for preempt =3D=3D U32_MAX whe=
n
you determine that all traffic classes are preemptible? What if less
than 32 traffic classes are used by the netdev? The check will be
bypassed, won't it?

Secondly, why should at least one queue be preemptible? What's wrong
with frame preemption being triggered by a tc-taprio window smaller than
the packet size? This can happen regardless of traffic class.=
