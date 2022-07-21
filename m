Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D78857D634
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 23:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbiGUVmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 17:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiGUVmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 17:42:12 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130050.outbound.protection.outlook.com [40.107.13.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6E17969C;
        Thu, 21 Jul 2022 14:42:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0PeJ2+fYe185hEZTnSs1KY4lk6gsIQYMLK2zIdc7e9VcSf8s71/SdqTsHyzKPHQzcpweTXXKNkygUZNrvnHRpNe7AazU4wSP7/9TC0/nAU3hWM7mF1nZDED49PwgdQ1h5rY/++FROBdS3yeOB7j9tp2vJFig2ILrdZQBlxWZWq0YE4cRvJE0oJJ1qSnbXuKSULlaAu+yz1/Y3QmxY1Ucp36bLjEghVx4q7ynlKc+CwAcl17efvG4v+EM8tBHH4FYZRg4bjGWR3VGankFErSTggEcL45L+8XNbUhZQ2Xs4D23/O5D3LkWk4ootg+H1NyKarfQQy848npJXLRSQMM4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7qAQGzw+4hg5GUHDmsZA7N8RrZtma3gzz71viTwPHSo=;
 b=mexUO5buAcL9ScxgbVlIuEmftDKREujnqQYhY9ErQnCvrcvTCujeovLa6Zon0xWxLKL10mjWCTDzTuRwkgDsA5GaZ/6iaLJYZjeE3MHBU3KLieDoqXwhE4nEkB6qBmODgNcoU7YLU/DXwD3ufEj46eMXgmwOE7GegQqG7SKgnhScQxlyfTghEOPrncqVHDkftKUGG4HDbOceUuk3wDYHTSlC5HFPRbju59e0NcrSEly+2scGsSvvcMP02fCyLLNFcHuyc8MAqPkKdfVqRiLKDAo+733DVn3v/cwlpE2XkAclYtRoSmDjf7asFQjr7JGq0mXTA7sWFsLK61xVWJe+Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qAQGzw+4hg5GUHDmsZA7N8RrZtma3gzz71viTwPHSo=;
 b=SSCqPJrKT4YJd5imnVRsIqCxMGpi1zroRLGaGgVfXm8EUkaUNl+0b7OXWb5CgrJyqBFH83TwRcdLdslPmnwt0s7FKSL4Hptr3lVxm+jyExkXLw1rD5va4GpeXgLFC8z3aRM295LrtJqTP2/CLe5y6srF09VB3b8Iub7TTiSoMj5U/k+x6qc0FH4Tc/AYge7riPW+rOqNYNg3vOghaHmyUDJ+G6eUb0+VCVI4LZwaQOh+WwIzrnt9b/wAkpNVmXTMxGvtRfE1VCLZGBz9bqOTZ2idVs8zKqJmRkPwIpSqDDtYOLamKWcz87ixZSq3lm93+TEA495Sk+jNra2Js4ZczQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB6839.eurprd03.prod.outlook.com (2603:10a6:20b:29a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 21:42:06 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 21:42:05 +0000
Subject: Re: [RFC PATCH net-next 0/9] net: pcs: Add support for devices probed
 in the "usual" manner
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Shawn Guo <shawnguo@kernel.org>, UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org
References: <2d028102-dd6a-c9f6-9e18-5abf84eb37a1@seco.com>
 <20220719181113.q5jf7mpr7ygeioqw@skbuf>
 <20220711160519.741990-1-sean.anderson@seco.com>
 <20220719152539.i43kdp7nolbp2vnp@skbuf>
 <bec4c9c3-e51b-5623-3cae-6df1a8ce898f@seco.com>
 <20220719153811.izue2q7qff7fjyru@skbuf>
 <2d028102-dd6a-c9f6-9e18-5abf84eb37a1@seco.com>
 <20220719181113.q5jf7mpr7ygeioqw@skbuf>
 <c0a11900-5a31-ca90-220f-74e3380cef8c@seco.com>
 <c0a11900-5a31-ca90-220f-74e3380cef8c@seco.com>
 <20220720135314.5cjxiifrq5ig4vjb@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <075c5ced-1185-2003-a265-12bce5a82076@seco.com>
Date:   Thu, 21 Jul 2022 17:42:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220720135314.5cjxiifrq5ig4vjb@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR12CA0003.namprd12.prod.outlook.com
 (2603:10b6:208:a8::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0848227a-f20f-4a43-33a9-08da6b61dafb
X-MS-TrafficTypeDiagnostic: AS8PR03MB6839:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z+Ia1XkMSZSk8WLnKZTGLac4L8xdzFZa5uZ+tZGAP/NjflbduKBYGMdUs/3ge6VdjHlpVMeEZFTzYcqxqgz5pjyHJPwItvcTbRmdCFqaB805LwG7qEJvWLcgagTxzKcB93WIahm0+8repoARdNJH9BIHQf2mCRl4suf0tU/K+3Vcav3mA96ZE3c2LeIewpHKnG1GuVHIT8KS08aW4FmIdDt4IIGTauuuouuP/xJzQAhPRs5UbNwRxZDMv3HWIGZ+Q9J9BktCYQuEM83qLMs0J+mbKdoBj+JL6V50tcBQ6Cvu1MorMAPVuiUb0qtMnYvTsK/42X2++TXFO0oLTpH+2V8cjWBykQvb6E57PoRCuo2vfsvhtkFl7N5uVb55k4wAkRmuNxVETpprKEecgSwID+Jf/be1LIuWw2oFZmu16T+LBOEcob7VL8Yb2bK8ziJhqwA67eG2vGOm19RwsVHjlORqw2wS3zNr6p7R9bVhrR+aG2VhOtHyce+UUM5UeEQvi8NSaTRLg0kzx4r5SiNkRxfUD6uLJpHJnCCTc3qxDa2UttjxwGgGHdTOuh1HkZMGoJ2F1o2LJ/3fBhWcGT39zEqrPa1g6x6p3aHnBZMG5hVYS/HCZKgBjjH4Lm0+DaKL6a2dTO1gi6X5p5XJA2FXZegi7Wrnrm4haRxfwQThWlRjyy7kJHBpfrIqCo2Y7mV0utsuX+6Snrw8Q3KG6smSzq5V0H2ruW2O76q+vbqzcLUaa7Id0/91exOgLt488naWoCHz1dd22J1xHmOrzIA4HgE2R0kfoeUXoC4os8D+9yyssUrf3RzDIE0BVpMFrLy9mtMtWB4gLNH71PSFV/ZAZGQr5Hogd/RFB4qmwXa5ztCrNxvWCosgtjav8mUVzTz5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39850400004)(346002)(376002)(396003)(366004)(38350700002)(2616005)(36756003)(6916009)(38100700002)(54906003)(31686004)(316002)(186003)(83380400001)(478600001)(2906002)(8676002)(7406005)(6486002)(8936002)(5660300002)(4326008)(66946007)(66476007)(66556008)(41300700001)(7416002)(44832011)(6666004)(31696002)(53546011)(26005)(52116002)(6506007)(6512007)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVpNcmM2VjAyUzVmZlVVWE5VQ0JLekgwS1lCKzBhbVRXc1FJOUxjV09kWlhV?=
 =?utf-8?B?Y2wyZ1JvMTVubWx6R0Jqdnh2eFlJaSsyMGQzbHJFQ1VmcTdwRG5DLzNjS0gw?=
 =?utf-8?B?MkZ6M0pBWWpNUGdtcmZXRG55Q1htTnBvNS9DWXk0VEVva2dGN0x2c3VDdjRO?=
 =?utf-8?B?RWFST3RXdHJuM292VVhYNWdLYjNKR2NMNDBUZEsxQzVTSkdyU3R5cFc2QWJr?=
 =?utf-8?B?UTlmR29QMy9BWkl2cDhhdEsvZjNuN0xwQml2VngyQk1WZVltejlkVUJsdDAy?=
 =?utf-8?B?aHhBRVN4eHZBYWFxSmdwNXN3eWcxMWJ3bnJqUjJlVGhkUi9QYnpYK3dxcERM?=
 =?utf-8?B?bys1b25FdU9sNjROdFQzdGlJcjJzNnNTSVE2czlJTnBXMkNKeStsNTlGbzRk?=
 =?utf-8?B?Z3MyKzFDb3ptTEI3ZHlpU2FZNS9WVkhnZ3YxUXNKWGkrZXJzcGQwNmNJUkZZ?=
 =?utf-8?B?ZUg2ZSs3b2I5dWQ3UDBBMVQvZ0UyUVFzRW9oV3h5bUZtbmhHOGxuMnlRb0dD?=
 =?utf-8?B?WmJHTDR3c29hSHhobnNzSFdSMDBLQUVVaVhpU0VFOXRBVWpFQ0djWENkL2VC?=
 =?utf-8?B?UFBUcVlIQ3dBaWV5Y1paNTBNOWF6dmh2TW8vRlNkUlN4SE5RbWVEZzdIdkNB?=
 =?utf-8?B?UE9iWHkyMkx6eGZRSG11K1Y1UE9MeCtJYzFVcVd2eTZQaEozM2w0cmNWN0xM?=
 =?utf-8?B?dlBYTEIzaUJqdmNGelRhcmxLNjFQeURqYWJkZEtETlhnbk5ld0lWVENCeGVD?=
 =?utf-8?B?YjJ0Y2pUdjlnQ2E0WGNyNFA2cnd4bnJWMTBFMHVwUWZvUU9WdUJlMnJ6VVpY?=
 =?utf-8?B?YTVmekczdENSU3EraTNtQklGUGYwZDZHVFBsSzVuRXdaOHFXSDFIbFdYZk0z?=
 =?utf-8?B?Tmh2QTFlUlhDZkc4K3AwVzJFcGRndERuRzZHYVhlYzkyQnlyaXE5QXdlaWxr?=
 =?utf-8?B?RmU0d3UrR1RmT3FlRDFLR2F3cnNWSjV2OVJPVVd1ZmJYMExsVGFKdVZuME9w?=
 =?utf-8?B?c1JFZ1JjdkkzUm1icStpV2kxeWtLUWNOUS9BVlhFZElBSktwM2k5eG1tc3c1?=
 =?utf-8?B?aE1sTTltOGxOS2JGczFnWUJaZStvRzM5RlJzRytrUVIwd1pveHFOWGF4MGNp?=
 =?utf-8?B?TGUyK2QyREdnRHArVVJOQkZ1MmNyZXZodm50TVlia3lhNWloK1Vqb0ZPYnZz?=
 =?utf-8?B?bnI5VG04QmxCa3hKbkxwcXcvZXZYbGdmTEsxK3NnQmNoWmswYTV2TDVGMU96?=
 =?utf-8?B?a1l4cmlIWms3cld5ZC9PSTlmUnNoaXRoMEc4dXBQUlBqd1RPL1UzNlY2WjFJ?=
 =?utf-8?B?L2lGR0IyTTQ2TlhMZUZjNkQrRk5EVjd6Mk5kd1h0QjVNaytwQ0RFNS9oZFky?=
 =?utf-8?B?ZTlHcUNCaFEyU24rcXpiL05RKzdVc1FlNXJwMENIUnQvQktXT2pOMVJkUzhJ?=
 =?utf-8?B?NDNqYVFRbUVJeTlIZ3I4V2MxNjNMZEltK1pDN3BaTWdsano1dDdoWUZpV2o3?=
 =?utf-8?B?ZHpranRiOS81RDRaQmwxODdhNjBuQkdOUjVkK1BnS3FkNzJnWkk1ZFRaV25Z?=
 =?utf-8?B?cG9VcHQzVWIrUG54cEEzL3M0L1J5cXZyRDJORFVXSTFUUitxZFR2L2laUTI5?=
 =?utf-8?B?ZCsvM2J6Qi83Z3h2Q1JZc1BVRFpWWFNzYTEyU0U0SUdWWFRqcDBSYTkyOERW?=
 =?utf-8?B?QnJwZmlLa0gyaG1rMmlaZkRNSmpaTmVvMm1aVUNicGtwbkVOQWhBbzM4WGg4?=
 =?utf-8?B?T2JILzE0RnBoa1lxbmlsVlIvZEx4Um5tMElKaHFKQk1WRGIxT3NMZGp6amFV?=
 =?utf-8?B?T0dhYWNNNWZhUnViSEV0azZZS3Y3NTBkMFZ0K091aE5BbFRHRGtaaG5GUDlM?=
 =?utf-8?B?bHhJQ1BkNzFMNGRIemQ5bHVFUEUzdEpmZHJ6TmZMY2NscWJhOTJDaHd6WEc3?=
 =?utf-8?B?R3pxQ2duRFFHYWVld1ZMeEprU0MreU9pMlJpRnNUNnRDcGk3T2xNc3M5cy9k?=
 =?utf-8?B?ZGVmOUFLQXpHNkRZWk95NFFjbXVrQ3h1UTlNbWdFcFdkcnRhaE5neDdpV3pD?=
 =?utf-8?B?SjhZVEg0TUFuN2xqbVRRY2duU1lnOUF1K2x4ano1SEhCbDRidVpJUmVXM0Rm?=
 =?utf-8?B?d3RiV2dwUlQyRVkvRHkzSlNvODRIVHRBZExvTDJNc1JnYXNLSDhta1hxQlhI?=
 =?utf-8?B?elE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0848227a-f20f-4a43-33a9-08da6b61dafb
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 21:42:05.8273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1FfjKhaxoOAi2Ol/pfivKCXeW/WNRPgJt61YQGshnt651JPSSYsq7CSXKK9CHYPY5y/3/Zo6l5itCADNFh6B1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6839
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/20/22 9:53 AM, Vladimir Oltean wrote:
> On Tue, Jul 19, 2022 at 03:34:45PM -0400, Sean Anderson wrote:
>> We could do it, but it'd be a pretty big hack. Something like the
>> following. Phylink would need to be modified to grab the lock before
>> every op and check if the PCS is dead or not. This is of course still
>> not optimal, since there's no way to re-attach a PCS once it goes away.
> 
> You assume it's just phylink who operates on a PCS structure, but if you
> include your search pool to also cover include/linux/pcs/pcs-xpcs.h,
> you'll see a bunch of exported functions which are called directly by
> the client drivers (stmmac, sja1105). At this stage it gets pretty hard
> to validate that drivers won't attempt from any code path to do
> something stupid with a dead PCS. All in all it creates an environment
> with insanely weak guarantees; that's pretty hard to get behind IMO.

Right. To do this properly, we'd need wrapper functions for all the PCS
operations. And the super-weak guarantees is why I referred to this as a
"hack". But we could certainly make it so that removing a PCS might not
bring down the MAC.

>> IMO a better solution is to use devlink and submit a patch to add
>> notifications which the MAC driver can register for. That way it can
>> find out when the PCS goes away and potentially do something about it
>> (or just let itself get removed).
> 
> Not sure I understand what connection there is between devlink (device
> links) and PCS {de}registration notifications. 

The default action when a supplier is going to be removed is to remove
the consumers. However, it'd be nice to notify the consumer beforehand.
If we used device links, this would need to be integrated (since otherwise
we'd only find out that a PCS was gone after the MAC was gone too).

> We could probably add those
> notifications without any intervention from the device core: we would
> just need to make this new PCS "core" to register an blocking_notifier_call_chain
> to which interested drivers could add their notifier blocks. How a> certain phylink user is going to determine that "hey, this PCS is
> definitely mine and I can use it" is an open question. In any case, my
> expectation is that we have a notifier chain, we can at least continue
> operating (avoid unbinding the struct device), but essentially move our
> phylink_create/phylink_destroy calls to within those notifier blocks.
> Again, retrofitting this model to existing drivers, phylink API (and
> maybe even its internal structure) is something that's hard to hop on
> board of; I think it's a solution waiting for a problem, and I don't
> have an interest to develop or even review it.

I don't either. I'd much rather just bring down the whole MAC when any
PCS gets removed. Whatever we decide on doing here should also be done
for (serdes) phys as well, since they have all the same pitfalls. For
that reason I'd rather use a generic, non-intrusive solution like device
links. I know Russell mentioned composite devices, but I think those
would have similar advantages/drawbacks as a device-link-based solution
(unbinding of one device unbinds the rest).

--Sean
