Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93AE935A447
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 19:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbhDIRBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 13:01:34 -0400
Received: from mail-db8eur05on2126.outbound.protection.outlook.com ([40.107.20.126]:33888
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234179AbhDIRBd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 13:01:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8ibWYqKkrBg8+sqrpxChjuWV8vFdYvbz2uUzUo8z9zYiKOKqmUVcpeIEKbdFMksyNtYHZzyUaK0/02tkRcz3HWeel8EjOcWWOzIfdOWBZNHKmI4kIxOQjKm1BpfHns4SzeyRFT568yvgNnCjgjdf3ovjwBVXJlODtXLhvPtnH2lG17M9oRPToX+uvX2LzqewDwB1q/i5cV9LDO+1nlmz0tQ5KFiNRJipF1RTJX/pOjH7B/aMpYkglHyfOYbrlgrjeOXzRUpkhWa7DEas7X4CA6ePmw9mISdgmoVP4p4ZHoYFaBXbxAW7aj0qahqmBCDAeCi2x2hmy3m1wSVg+vrwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVTvtJXMWoME4RjDTuL5N5UCaLSIWZ67FwVspivLgec=;
 b=CKsezhWyLVI0yzvpkhjUjqph641AoAWBGcdrgAUp8Q6Q2n1qSHDmyj+w6brrqw7phk69JcEkSiUKRgbh/wbcdmDdbXI4LK6x1qwtsuV/6ST9v48mfxFUKVgXGtoSxHXUDpfSFmYRwuWDANIJp3++ut2irMYsqnQ7BQ/70G34txm9qgcZcRoUL5+gKnJh/kdgeV5rS6AHIaX3psbxibzGxBn7uSnROEx83Iai153t8MLMpIbRUIxyhm2mr4iGjsIgvMxn24IHlFvTN1KjJVPohn4EDfZtOTsVzTprtdM1ZLHsvpThL0ngGtDUMXW+OWrJGEsdggomh5/GQPUuL4UmCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVTvtJXMWoME4RjDTuL5N5UCaLSIWZ67FwVspivLgec=;
 b=d+I8wASEwwVBUdQvNq/wRneMHeLpD2ACc7FyauwftdqefR57o7yPfOV67b3Jva6T1AeH64vzBUX/0eV7cv1hNemK4S1aIpi6h71WkZ3Qs3o9vi8fKw5D9QqQ8TvfC3aGoWyVjVL7oIjjgOnPBxBbv3l9HFp4snZ7A3qTIvUG6jo=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0187.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:cb::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.21; Fri, 9 Apr 2021 17:01:17 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c%7]) with mapi id 15.20.3999.035; Fri, 9 Apr 2021
 17:01:17 +0000
Date:   Fri, 9 Apr 2021 20:01:14 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, kuba@kernel.org, idosch@idosch.org,
        Parav Pandit <parav@nvidia.com>
Subject: Re: [RFC] net: core: devlink: add port_params_ops for devlink port
 parameters altering
Message-ID: <20210409170114.GB8110@plvision.eu>
References: <20210409162247.4293-1-oleksandr.mazur@plvision.eu>
 <ce46643a-99ad-54e8-b5ed-b85ca35ecbcb@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce46643a-99ad-54e8-b5ed-b85ca35ecbcb@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM6P191CA0022.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8b::35) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6P191CA0022.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8b::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 17:01:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e460a11c-701f-4c3a-ccc5-08d8fb791721
X-MS-TrafficTypeDiagnostic: HE1P190MB0187:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0187A7F4325F7AB3D0BE5A6B95739@HE1P190MB0187.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mk9VCa3P0PdT/EqNIYruzT4BJ999wzXR0Hm4pzw2ycvWZxmjl+oQvDNUJBNixHElkDhejGRvcKDEYv5iPSI0UhsR4eh0cq1AV7lV04CFsQAWdHvAXzPSgDLnFMlZW7qg+VpTA8C63W1NPCIn0QRUhYlVuW01xakn4kRjaZMoW+fBryamx6C+V3BY7c1tlYeJXNAg6sL/pwlNp32Lao8XrZB7ggtg2FgWfF9EXgnM+KRCRa+o7SoQIS2ywar3+H6aWtb7m+XOV9adbQlYCSEJ02JbNWmEloF20CvMRubRo5if0oKr/UaFyVo0CvkmSrx4bEvpoPrZsEQTzb/TTFUV3BZUgYg+tHymyQPj9a/63JFOHWDjat4STUlDcgf+eRjf/VuyL1FphrQWoABGf5T44OFkbT/WKRH/0IFXOe6GIh2DUkPZ9k7/vQGMyr0O0FTMbV7rO5oxZJrQ8n51KHe+wqoPeIcE3YuO3myfu26F5o4l/Ze40jmdZoIjDZJOgVZA3ZnBSBJYWNyu71HzR4/ojrgs1oV5Kn2F/s4Pgrl14mFVr5PM6vV3Tb/rikCksvhVHc/B0ZoPZrq1kPKWXexmauRweWaPp2uuFY5m+EUX1Yua9it3+gzIHfcYeDTAQcJFEg19/u30Ch3OX5Em3iC7xE4Byzc/kzlYslshertXbM+MyofGHHIGabseqSNjoVjq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(39830400003)(366004)(136003)(346002)(396003)(7696005)(2906002)(186003)(38100700001)(26005)(52116002)(55016002)(44832011)(38350700001)(2616005)(1076003)(956004)(16526019)(53546011)(36756003)(30864003)(5660300002)(33656002)(8886007)(86362001)(6916009)(8676002)(54906003)(8936002)(316002)(66946007)(478600001)(83380400001)(4326008)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Swei2W36aYAmCkMuZopVoSBqcg1vKAhZ+etjrN/E6Xm4K6CpjazctjyT1jKv?=
 =?us-ascii?Q?sramHTvxnnA2rIvjgT/rXdq7xT7Hw3c1goj0ypoDegvodBZc2ut24Bl6cDDK?=
 =?us-ascii?Q?s71EXKtJTrGyY2Kl2xFzZ7lLhh73L6VTs7KgJiIyjJ5aJQfV7+2gutY78kEd?=
 =?us-ascii?Q?fPmRAVEatnv8QiCnesMhAEKrVBZUgfWeoEcH4dt1l0astw4AiVpVtArBX6BR?=
 =?us-ascii?Q?CMfBmtzGRKqZC1RlMfjzVuWmiXLbCga9m8qmR3+6S+hIchTol1jGMDkK6KEY?=
 =?us-ascii?Q?rhuSLuo2b1FpLLPn1E99A9vG7cbyOSK4x0VdYg9DJH68cyKd/m8Bk96CQDgv?=
 =?us-ascii?Q?DXTnCxRC0RASLVjhcKVZNZ5pnqJvEaCvEoY/awHhOnGieBnNy7AmdIYTX/49?=
 =?us-ascii?Q?P6iIZ22aGOZ6KXCfpQaUHKPDIexRNaQ/Ag+PV0Ns/+/RN2cU5RYh5B/UrCxM?=
 =?us-ascii?Q?rDz82T4U2xxXxpmwc/a7vc5ENjhWtZAqbd6JmrCstGiXh2qmAre7eW4QWR6t?=
 =?us-ascii?Q?GsJ9S2HmbDjQUf0DfknTbmiFDzy0XOSr87zL/J6gXTVyJzBHcwq5/ShqegFj?=
 =?us-ascii?Q?EjHh05n3gABilsLXm/osKEiYYVcEoFWChNOvpoKS3E+hz0AqTRN9L9ZfT0b8?=
 =?us-ascii?Q?U3ecQK+2CriRb4SRHKQ/HtZvWmMoem9QuCCc7jTX9MkmxUZ4tU+qvDzdYTzZ?=
 =?us-ascii?Q?1rLd167Q20nTCE60c0Oy3ajw74P5GYJerb/oyx99vYdBbcNaazvvj4c1PH2c?=
 =?us-ascii?Q?ufTr8lfI7JlpzcdhvcXqV14wd3hxJmppF+P1kadJEhsX7kznghBJ8DEJmkMK?=
 =?us-ascii?Q?64NnBa7U6SmTzDBR48cNNEpcdJBiyx+vPeumLiCl2OR3obdFpjz/qV8fyyed?=
 =?us-ascii?Q?WbyPhWv1B/okPLyxxWftHE46sx9ELfFk3ieMOdtS49vrbybBEqEHtbofgL2n?=
 =?us-ascii?Q?ZR3sn53SLssNV+vzYEJ9jm0RPun4Ww9O2ceiVrljkLv2e0yOV/en77NBVkYc?=
 =?us-ascii?Q?lKv3/GuSMsndv6/V0bZguI/jOPz7I9prUCM2kqybQMaOzK2Axp7ms5yRdcmt?=
 =?us-ascii?Q?ng4sy7VZ/Fe2iCn1sayvDtFxEZUruVVrVNchnqS/fYrtlBkJBYT1USqjbh2g?=
 =?us-ascii?Q?vFIajC7ZVkoENkP3c++afe9qmstU28tZjZGQGZ2kBeGOw6rZtgvvu+AmffCo?=
 =?us-ascii?Q?cX/pPEdFLa7tOy0s1x3/zOo3FAPxMD7unJ2sFJnmdvH9Fh9un5Ov2am/zw6D?=
 =?us-ascii?Q?ZPCDWKqrbjgClK+yDD4ZGIojxkTxHb9q6fF9axLCqJLg/YFftr7k21mq5eYC?=
 =?us-ascii?Q?jh9FV/2QbBTtWPcjeRlxXoei?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: e460a11c-701f-4c3a-ccc5-08d8fb791721
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 17:01:17.2939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F6HIet061kOhDnooecdjccJtWN6AAO75twmHiLDAwUrOMejBbZKEgKVIa93xgNr3i7FvpGX8Ni+473szSBkjGN+InI7icL9dQuD5hLfRSDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0187
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sridhar,

On Fri, Apr 09, 2021 at 09:51:13AM -0700, Samudrala, Sridhar wrote:
> On 4/9/2021 9:22 AM, Oleksandr Mazur wrote:
> > I'd like to discuss a possibility of handling devlink port parameters
> > with devlink port pointer supplied.
> > 
> > Current design makes it impossible to distinguish which port's parameter
> > should get altered (set) or retrieved (get) whenever there's a single
> > parameter registered within a few ports.
> 
> I also noticed this issue recently when trying to add port parameters and
> I have a patch that handles this in a different way. The ops in devlink_param
> struct can be updated to include port_index as an argument
> 

We were thinking on this direction but rather decided to have more strict
cb signature which reflects that we are working with devlink_port only.

> devlink: Fix devlink_param function pointers
> 
> devlink_param function pointers are used to register device parameters
> as well as port parameters. So we need port_index also as an argument
> to enable port specific parameters.
> 
> Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> 
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 57251d12b0fc..bf55acdf98ae 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -469,12 +469,12 @@ struct devlink_param {
>         bool generic;
>         enum devlink_param_type type;
>         unsigned long supported_cmodes;
> -       int (*get)(struct devlink *devlink, u32 id,
> -                  struct devlink_param_gset_ctx *ctx);
> -       int (*set)(struct devlink *devlink, u32 id,
> -                  struct devlink_param_gset_ctx *ctx);
> -       int (*validate)(struct devlink *devlink, u32 id,
> -                       union devlink_param_value val,
> +       int (*get)(struct devlink *devlink, unsigned int port_index,
> +                  u32 id, struct devlink_param_gset_ctx *ctx);
> +       int (*set)(struct devlink *devlink, unsigned int port_index,
> +                  u32 id, struct devlink_param_gset_ctx *ctx);
> +       int (*validate)(struct devlink *devlink, unsigned int port_index,
> +                       u32 id, union devlink_param_value val,
>                         struct netlink_ext_ack *extack);
>  };
> 
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 151f60af0c4a..65a819ead3d9 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -3826,21 +3826,23 @@ devlink_param_cmode_is_supported(const struct devlink_param *param,
>  }
> 
>  static int devlink_param_get(struct devlink *devlink,
> +                            unsigned int port_index,
>                              const struct devlink_param *param,
>                              struct devlink_param_gset_ctx *ctx)
>  {
>         if (!param->get)
>                 return -EOPNOTSUPP;
> -       return param->get(devlink, param->id, ctx);
> +       return param->get(devlink, port_index, param->id, ctx);
>  }
> 
>  static int devlink_param_set(struct devlink *devlink,
> +                            unsigned int port_index,
>                              const struct devlink_param *param,
>                              struct devlink_param_gset_ctx *ctx)
>  {
>         if (!param->set)
>                 return -EOPNOTSUPP;
> -       return param->set(devlink, param->id, ctx);
> +       return param->set(devlink, port_index, param->id, ctx);
>  }
> 
>  static int
> @@ -3941,7 +3943,8 @@ static int devlink_nl_param_fill(struct sk_buff *msg, struct devlink *devlink,
>                         if (!param_item->published)
>                                 continue;
>                         ctx.cmode = i;
> -                       err = devlink_param_get(devlink, param, &ctx);
> +                       err = devlink_param_get(devlink, port_index, param,
> +                                               &ctx);
>                         if (err)
>                                 return err;
>                         param_value[i] = ctx.val;
> @@ -4216,7 +4219,8 @@ static int __devlink_nl_cmd_param_set_doit(struct devlink *devlink,
>         if (err)
>                 return err;
>         if (param->validate) {
> -               err = param->validate(devlink, param->id, value, info->extack);
> +               err = param->validate(devlink, port_index, param->id, value,
> +                                     info->extack);
>                 if (err)
>                         return err;
>         }
> @@ -4238,7 +4242,7 @@ static int __devlink_nl_cmd_param_set_doit(struct devlink *devlink,
>                         return -EOPNOTSUPP;
>                 ctx.val = value;
>                 ctx.cmode = cmode;
> -               err = devlink_param_set(devlink, param, &ctx);
> +               err = devlink_param_set(devlink, port_index, param, &ctx);
>                 if (err)
>                         return err;
>         }
> 
> > 
> > This patch aims to show how this can be changed:
> >    - introduce structure port_params_ops that has callbacks for get/set/validate;
> >    - if devlink has registered port_params_ops, then upon every devlink
> >      port parameter get/set call invoke port parameters callback
> > 
> > Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> > ---
> >   drivers/net/netdevsim/dev.c       | 46 +++++++++++++++++++++++++++++++
> >   drivers/net/netdevsim/netdevsim.h |  1 +
> >   include/net/devlink.h             | 11 ++++++++
> >   net/core/devlink.c                | 16 ++++++++++-
> >   4 files changed, 73 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> > index 6189a4c0d39e..4f9a3104ca46 100644
> > --- a/drivers/net/netdevsim/dev.c
> > +++ b/drivers/net/netdevsim/dev.c
> > @@ -39,6 +39,11 @@ static struct dentry *nsim_dev_ddir;
> >   #define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
> > +static int nsim_dev_port_param_set(struct devlink_port *port, u32 id,
> > +				   struct devlink_param_gset_ctx *ctx);
> > +static int nsim_dev_port_param_get(struct devlink_port *port, u32 id,
> > +				   struct devlink_param_gset_ctx *ctx);
> > +
> >   static int
> >   nsim_dev_take_snapshot(struct devlink *devlink,
> >   		       const struct devlink_region_ops *ops,
> > @@ -339,6 +344,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
> >   enum nsim_devlink_param_id {
> >   	NSIM_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
> >   	NSIM_DEVLINK_PARAM_ID_TEST1,
> > +	NSIM_DEVLINK_PARAM_ID_TEST2,
> >   };
> >   static const struct devlink_param nsim_devlink_params[] = {
> > @@ -349,6 +355,10 @@ static const struct devlink_param nsim_devlink_params[] = {
> >   			     "test1", DEVLINK_PARAM_TYPE_BOOL,
> >   			     BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
> >   			     NULL, NULL, NULL),
> > +	DEVLINK_PARAM_DRIVER(NSIM_DEVLINK_PARAM_ID_TEST2,
> > +			     "test1", DEVLINK_PARAM_TYPE_U32,
> > +			     BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
> > +			     NULL, NULL, NULL),
> >   };
> >   static void nsim_devlink_set_params_init_values(struct nsim_dev *nsim_dev,
> > @@ -892,6 +902,11 @@ nsim_dev_devlink_trap_policer_counter_get(struct devlink *devlink,
> >   	return 0;
> >   }
> > +static const struct devlink_port_param_ops nsim_dev_port_param_ops = {
> > +	.get = nsim_dev_port_param_get,
> > +	.set = nsim_dev_port_param_set,
> > +};
> > +
> >   static const struct devlink_ops nsim_dev_devlink_ops = {
> >   	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT |
> >   					 DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
> > @@ -905,6 +920,7 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
> >   	.trap_group_set = nsim_dev_devlink_trap_group_set,
> >   	.trap_policer_set = nsim_dev_devlink_trap_policer_set,
> >   	.trap_policer_counter_get = nsim_dev_devlink_trap_policer_counter_get,
> > +	.port_param_ops = &nsim_dev_port_param_ops,
> >   };
> >   #define NSIM_DEV_MAX_MACS_DEFAULT 32
> > @@ -1239,6 +1255,36 @@ int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
> >   	return err;
> >   }
> > +static int nsim_dev_port_param_get(struct devlink_port *port, u32 id,
> > +				   struct devlink_param_gset_ctx *ctx)
> > +{
> > +	struct nsim_dev *nsim_dev = devlink_priv(port->devlink);
> > +	struct nsim_dev_port *nsim_port =
> > +		__nsim_dev_port_lookup(nsim_dev, port->index);
> > +
> > +	if (id == NSIM_DEVLINK_PARAM_ID_TEST2) {
> > +		ctx->val.vu32 = nsim_port->test_parameter_value;
> > +		return 0;
> > +	}
> > +
> > +	return -EINVAL;
> > +}
> > +
> > +static int nsim_dev_port_param_set(struct devlink_port *port, u32 id,
> > +				   struct devlink_param_gset_ctx *ctx)
> > +{
> > +	struct nsim_dev *nsim_dev = devlink_priv(port->devlink);
> > +	struct nsim_dev_port *nsim_port =
> > +		__nsim_dev_port_lookup(nsim_dev, port->index);
> > +
> > +	if (id == NSIM_DEVLINK_PARAM_ID_TEST2) {
> > +		nsim_port->test_parameter_value = ctx->val.vu32;
> > +		return 0;
> > +	}
> > +
> > +	return -EINVAL;
> > +}
> > +
> >   int nsim_dev_init(void)
> >   {
> >   	nsim_dev_ddir = debugfs_create_dir(DRV_NAME, NULL);
> > diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
> > index 7ff24e03577b..4f5fc491c8d6 100644
> > --- a/drivers/net/netdevsim/netdevsim.h
> > +++ b/drivers/net/netdevsim/netdevsim.h
> > @@ -203,6 +203,7 @@ struct nsim_dev_port {
> >   	unsigned int port_index;
> >   	struct dentry *ddir;
> >   	struct netdevsim *ns;
> > +	u32 test_parameter_value;
> >   };
> >   struct nsim_dev {
> > diff --git a/include/net/devlink.h b/include/net/devlink.h
> > index 853420db5d32..85a7b9970496 100644
> > --- a/include/net/devlink.h
> > +++ b/include/net/devlink.h
> > @@ -1189,6 +1189,16 @@ enum devlink_trap_group_generic_id {
> >   		.min_burst = _min_burst,				      \
> >   	}
> > +struct devlink_port_param_ops {
> > +	int (*get)(struct devlink_port *port, u32 id,
> > +		   struct devlink_param_gset_ctx *ctx);
> > +	int (*set)(struct devlink_port *port, u32 id,
> > +		   struct devlink_param_gset_ctx *ctx);
> > +	int (*validate)(struct devlink_port *port, u32 id,
> > +			union devlink_param_value val,
> > +			struct netlink_ext_ack *extack);
> > +};
> > +
> >   struct devlink_ops {
> >   	/**
> >   	 * @supported_flash_update_params:
> > @@ -1451,6 +1461,7 @@ struct devlink_ops {
> >   				 struct devlink_port *port,
> >   				 enum devlink_port_fn_state state,
> >   				 struct netlink_ext_ack *extack);
> > +	struct devlink_port_param_ops *port_param_ops;
> >   };
> >   static inline void *devlink_priv(struct devlink *devlink)
> > diff --git a/net/core/devlink.c b/net/core/devlink.c
> > index 737b61c2976e..20f3545f4e7b 100644
> > --- a/net/core/devlink.c
> > +++ b/net/core/devlink.c
> > @@ -3918,6 +3918,7 @@ static int devlink_nl_param_fill(struct sk_buff *msg, struct devlink *devlink,
> >   				 enum devlink_command cmd,
> >   				 u32 portid, u32 seq, int flags)
> >   {
> > +	struct devlink_port *dl_port;
> >   	union devlink_param_value param_value[DEVLINK_PARAM_CMODE_MAX + 1];
> >   	bool param_value_set[DEVLINK_PARAM_CMODE_MAX + 1] = {};
> >   	const struct devlink_param *param = param_item->param;
> > @@ -3941,7 +3942,20 @@ static int devlink_nl_param_fill(struct sk_buff *msg, struct devlink *devlink,
> >   			if (!param_item->published)
> >   				continue;
> >   			ctx.cmode = i;
> > -			err = devlink_param_get(devlink, param, &ctx);
> > +			if ((cmd == DEVLINK_CMD_PORT_PARAM_GET ||
> > +			    cmd == DEVLINK_CMD_PORT_PARAM_NEW ||
> > +			    cmd == DEVLINK_CMD_PORT_PARAM_DEL) &&
> > +			    devlink->ops->port_param_ops) {
> > +
> > +				dl_port = devlink_port_get_by_index(devlink,
> > +								    port_index);
> > +				err = devlink->ops->port_param_ops->get(dl_port,
> > +									param->id,
> > +									&ctx);
> > +			} else {
> > +				err = devlink_param_get(devlink, param, &ctx);
> > +			}
> > +
> >   			if (err)
> >   				return err;
> >   			param_value[i] = ctx.val;
> 
