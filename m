Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55E0617965
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 10:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiKCJJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 05:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiKCJJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 05:09:40 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2044.outbound.protection.outlook.com [40.107.100.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FABDE4
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 02:09:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O/WaV222BPyLp0rSy9ODdj1HVOVbdNk6g9vCl3Njei3gnc29+csZ5/cAQX2cMQPvVzlfM+eK/4bscnwjqjk0yFHZ3+znh+WU4DFPVBKsb1K4BOJVABfxmsYksXmN4gPXau8nI3g3Sv9CmsWMzPOzbcYoITkSYB7Wv4NBuX5enmYCJRmi91i+ZVR+0lDlyeFqkKxZcQEwZBGwb5oWDfS6xgo2+KE7tjiZwANYOm9XRH468KdSEdKTRdrN37oUIcdKvDBQ93DUEswtcCA5DquYH2euSPIxJbv5XsdUHXzf7d5VjKT/TO6x4oruJ6Fj1hbtv4a3YiivjXmG2m7y1vbSyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4sNp7lxVoHrm2s1uAOfiWgASd+t4Thnsz5ago2CYC9k=;
 b=FL8ZNv0c2jLpP639hUHQvkXxEgECj9Fkpxin2en16jHC0XEs+vCWIF8LnQmNd7bzAzc3oedsFgun1jMzfDjjnAzUeZtU4POcvS8lmEk4FVFexJ+6GjJ/am8eJRBl3jxY11i0IZPACL2xEQCOIbK2OlgBx/UJTJIib8iMdLCDemGVLlgBfHFXHe4B3MutjXgIqTC3Su32/eX+FSdXdfcxmOpxjX6VtlSPeGvF8uTnChhXpmUGRC919h6XbiS89PNfXEfD5Iw8HolastfTtBvM1f+hwRGi4GDA2maqsfCS/x34jhj/I8ZZ/FGDfVasMGwtZPfyr0j2Y0ck/NKR7eAQFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4sNp7lxVoHrm2s1uAOfiWgASd+t4Thnsz5ago2CYC9k=;
 b=HZQGGUX5TI4Y5inNjJKludRfjdSYpooaaL4td6lQuGDml3gkxzP9a33yMKpT1wKxdkg23YfDi0LjAqF4F4diLm0pyki8yWqxlCbPFQOj+S/4W6fdQxAMynYAG+UeuyVPqJqdWCuqmZHMwl3gp2xZ2+DxanU6KoUuRPzkdcXYGexhl1NYJTbRd/809yXTfwg7ctxb7vw/t/1KrrZGIN2/TiQHQH4snYP3izoEoRjde/rA9gWmPprULRZEFQAbq62nSxPDxD9tv3ofuSbwH/5++8OWnEET3zBUA+kzB4SLsW3KIRtlOsAekWOclFZ19ZGbKsayLY97om2Uoa0rvDBS6w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL1PR12MB5801.namprd12.prod.outlook.com (2603:10b6:208:391::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Thu, 3 Nov
 2022 09:09:37 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5791.020; Thu, 3 Nov 2022
 09:09:37 +0000
Date:   Thu, 3 Nov 2022 11:09:30 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [RFC PATCH net-next 17/19] bridge: mcast: Allow user space to
 add (*, G) with a source list and filter mode
Message-ID: <Y2OFSq7AZRARG9ov@shredder>
References: <20221018120420.561846-1-idosch@nvidia.com>
 <20221018120420.561846-18-idosch@nvidia.com>
 <e3a74c46-0542-4f21-4975-5bd22bb62ab9@blackwall.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3a74c46-0542-4f21-4975-5bd22bb62ab9@blackwall.org>
X-ClientProxiedBy: VI1PR0701CA0043.eurprd07.prod.outlook.com
 (2603:10a6:800:90::29) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BL1PR12MB5801:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b85cf73-5850-4eb1-8a2f-08dabd7b21d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nukuohx+/V5GezwMlcT3jv2AY3CpSs10lFrIPzBD/VHfruEk3GBpZQgkObAkavZsGvEiFNqmwfulL+1OWoGuS9Ekigpm71+W4knNHKB7KeonBfhUG7VdIxYTMmFuwzLxN+dV5qSydTh/qdaXUFdzOUBaPLI81dPqwSJHtavM7gdnkA+pFA06roTK/OFoyyUbd9klQXZdQktFPLfpeVutIShJjMEUolvd3IRLImgwTgFtPY51Z2dI8/NgTkf5dT5jPZrxXQl1G1O1QpdzyDT/qOkfueyFtJHWTBHYqCadZmAhtJ7jCUEpj/RRMKE+YxUQLg5TUG6qwO1UjTkE5EB7zzZTdTswVMwCeSI67Nv1qdYCr6JqQP9Dbt8OKW60py0T6QaDBcGdOH3SixovpZw55n7dZXuSsxz/hUXp9ISFQ43vUfTNuWkwIYqwjwyIr/mBLYPvk8M/ih+aLgG1jtijHnJpLXF7woS6gdm8WVwAAF4WjBmd+vivmsNiEBaD8jji2AQXUDx9a/aePNZkyRu5ltRq6pOFU8JF3/f6pDT6kVgNQr1n0MzlgsDKeUtBYrjLzhCi8V7ohJvAiZSKVzQOzYmwwvQVfRWWq+EIq7HDhv0wbwSx0HNnANw7VbnTJxAwGo35CQcKQKtd7JxZQB9Z+VCTNlcebsU3NGV9ssOHYuTsk3yTmknBCNS5q4KhYgaa5EcQ/9dwx9ZsDmA6eDxY2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(346002)(396003)(366004)(136003)(376002)(39860400002)(451199015)(83380400001)(478600001)(107886003)(6666004)(6506007)(2906002)(6486002)(86362001)(6512007)(53546011)(33716001)(26005)(9686003)(186003)(4326008)(316002)(8676002)(66476007)(66946007)(38100700002)(6916009)(8936002)(41300700001)(66556008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lRfhbmhh7pFmPJ1UDokVKaDD4jh2XL34sUz4DDN9fJ2aFRYJFaX2vxT0nJfn?=
 =?us-ascii?Q?HEK86qLj8qSY37dezIqmnk39Gc/9VoIyExDI5PC9jJc9cT2+yLqGuSLZsAyh?=
 =?us-ascii?Q?gnz3BN1hMVZ67VquDnSLNmDjwg6YedDyf5Di6NTIVdvgX7JaHvVKBGt3fjdn?=
 =?us-ascii?Q?H11TuE/aDUh/V0/QChR2T0BcGVNuTWPo/X5Lj8SG3A7vBfdp7UHQ9/CTReN2?=
 =?us-ascii?Q?KIPUe2mfprY+KAvXW9Q7916rzsY2JMuwyTq8G76rrF0Hzt6Iitqii4uSXTvn?=
 =?us-ascii?Q?nXiEcpwOEWwXYntpDqshOAjWKwGZfbsrbDHYGSsmflqEj1FDT/QlYLpU0rUI?=
 =?us-ascii?Q?r9DFqTYQO9zULIT30k3X2LRvs6MCi6agSdZJEOybrOx56SigH+ZAlewWXIth?=
 =?us-ascii?Q?/DrIVVmfhsqn8Ev5Ze+IqmW1KtpyQs5utEPGVOSPVGHIPw4HD7jhMDCzv4se?=
 =?us-ascii?Q?c+jh0x5D12tMYsqque3IT1h3ssxd6iKKj7XMlBYDRoknX2HqMPlUo8OIGdjB?=
 =?us-ascii?Q?MmArFeWJd9oKoh8LpVBSY0/ECSr8nNJYMo+ZGzXlYFxFzeaklfwz+vEDctaX?=
 =?us-ascii?Q?ESgFRp5R/TJ262VaiuBdKMhGu2b0lZRNT8Fuzcdzdirnrcp/y9dAmOAIA+40?=
 =?us-ascii?Q?G2Xy83FNVhTi1xxgPoYQc9a3RxfAJgPAV/4jCH7VU33bOaCDgm2aovB4Atn9?=
 =?us-ascii?Q?B9YjDy0FaooQVxpUANwj6qn5KTQWrx+YdIES2H9L9I8KsqwUWywhlwO19SId?=
 =?us-ascii?Q?FRBX1A06lzBMeIb6RU1E3UuUKQd5zmQj4Q8mT2PvLgGUT8V+b4/C9IG5AOA2?=
 =?us-ascii?Q?2SCWzlaRqsMAz9+k96scFMApRBVj8fEaAXaBV2awi3gDZRED3gJveBSM5l7Y?=
 =?us-ascii?Q?okJjlVPoMOt547+GqlpNAmDJtG090uNiz3j5r8ld/r2RWitcCIHBuyJ3rQXJ?=
 =?us-ascii?Q?fJcpA2Itxr60NdJuCuBizqCfz1tYfTsWIvknbJxTtip/DmJHLz04bEyl+qI7?=
 =?us-ascii?Q?7jhnM/XrJVdNa7eAFgF0JWiGMQpgkQuN17GQ68romXAHEH8FwKr+dk3rXs2l?=
 =?us-ascii?Q?8v0UeRuuDAA+gow0/hGRlapKRb7dtmxedUM2iyNhEGWb+eOPMPA9Lo7v4nol?=
 =?us-ascii?Q?ipvYvJKO6xHBxrxeM1m4P6T4Dj6xOOV4KdCirGwlTb6bZVE9vseRXnO0WM6n?=
 =?us-ascii?Q?YyhRC37/vGGFH506ZHIgWqUDURKfz9K0S7YtlKWITqcvz0onOj6Bs2h3eaYI?=
 =?us-ascii?Q?/pzQwmcYITdCpI2f+RR/hpt7BWwEJVnfh3ipb50/2lc16EM1cwjso9VgOCrW?=
 =?us-ascii?Q?Qq7zY5a2eLRM4MqsGonKvMC/rXKm2XH6atYCrnJ6IAP6QCv2OwrhShAJuG/R?=
 =?us-ascii?Q?twiQfQBRi/RguieGjVS8Bcfd+3vW/XjpKSxe1gOjjEWJtDfdAV7E4MnPOm5j?=
 =?us-ascii?Q?5WHpHDqTqGhapJduHQAfP4jwo5hA7Ki1MwpTlJakePZDz0Oz4QrPvFL1qVzw?=
 =?us-ascii?Q?jo0nvytXks2y8HG1EETW98n4bDnu1CbMc/Z95UYErygeK68Q4C79nkyL/AGC?=
 =?us-ascii?Q?vJXsyGWFajqtJrGW03ZL1CSwDyaing7bKPCW/Fz/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b85cf73-5850-4eb1-8a2f-08dabd7b21d2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 09:09:37.5074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +jpA/LAekqTb+L0N6RoMhMj0KTwqion5hiuh202EOlfKdrgvPC9MxKB3iWS1oCmLwQAlbhFsIE0sH+JqPuhRfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5801
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 04:28:23PM +0300, Nikolay Aleksandrov wrote:
> On 18/10/2022 15:04, Ido Schimmel wrote:
> > +static int br_mdb_config_src_list_init(struct nlattr *src_list,
> > +				       struct br_mdb_config *cfg,
> > +				       struct netlink_ext_ack *extack)
> > +{
> > +	struct br_mdb_src_entry *src, *tmp;
> > +	struct nlattr *src_entry;
> > +	int rem, err;
> > +
> > +	nla_for_each_nested(src_entry, src_list, rem) {
> > +		err = br_mdb_config_src_entry_init(src_entry, cfg, extack);
> 
> Hmm, since we know the exact number of these (due to attr embedding) can't we allocate
> all at once and drop the list? They should not be more than 32 (PG_SRC_ENT_LIMIT) IIRC,
> which makes it at most 1152 bytes. Might simplify the code a bit and reduce allocations.

I didn't see how I can reliably determine the exact number of source
entries without going all the 'MDBE_SRC_LIST_ENTRY' attributes. I mean,
the entries can have varying sizes in case user space provided mixed
IPv4/IPv6 sources (which will be rejected later on) and in the future we
might have more attributes per-source entry other than the address
(e.g., source timer), which might be specified only for a subset of the
entries.

So, I did end up converting to an array like you suggested, but I'm
going over the entries twice. Once to understand how large the array
should be and again to initialize it. It's control path so it should be
fine. The advantages are that the number of allocations are reduced and
that I can reject a too long source list before doing any processing:

if (cfg->num_src_entries >= PG_SRC_ENT_LIMIT) {
	NL_SET_ERR_MSG_FMT_MOD(extack, "Exceeded maximum number of source entries (%u)",
			       PG_SRC_ENT_LIMIT);
	return -EINVAL;
}

[...]

> > +static void br_mdb_config_fini(struct br_mdb_config *cfg)
> > +{
> > +	br_mdb_config_attrs_fini(cfg);
> > +}
> > +
> 
> Is there more coming to these two _fini helpers? If not, I think one would be enough, i.e.
> just call br_mdb_config_src_list_fini() from br_mdb_config_fini()

Done.

Thanks!
