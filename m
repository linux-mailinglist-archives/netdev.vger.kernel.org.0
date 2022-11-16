Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40E562BE41
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 13:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237870AbiKPMhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 07:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239103AbiKPMg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 07:36:59 -0500
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2063.outbound.protection.outlook.com [40.107.103.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5AC64E3
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 04:36:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALrmq/4d+8bRcf78OZRuGTDRJJQc0rKL0gNy3rGlVNr02Y8/9uuuSj59Dly7VBdS1J9Obin+nn78MLZVqAflKO4TydUANpMNurN3WNb7ulFhUM8CF1TylFc3cuAI02MJFAoYnPATDVxcJuszcxbnmEKjMSQaHrf442SIOtRiQTBLKRCced1tTc6gxosy9dSDyGUIv1Zh673aZzAP7ZFRIxu1MDMbxbwnoFQRMF/oItjGPEhg/phOXgiug7aptfB4GjSGAz6/OUf+xWJEyU50fkEy8Lo0H+oRZBWgVpmUB7FjKSl7WRqhtMohkwZGSz8w5IHnYGP1Q522T+zcoO1RBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=37EtGnJoRu2YMF/Oy8vFWb6UI3PVDTHFcXTZaIEEaiM=;
 b=EDDMPbC0LmpSrG4a0WJ4b85IimBruksF2aZ6bJkSKH2LB47EazhOhnY//UnJbeAMxITnSVbWMMfcJgI8NixDC3zCdY1VPw6qoKHANIx7LPTnoQzOHEALRuFGY1xT3TzPNIlQoUf7Rwjhx/7wgs0MnVD2DHQh/zUybYVCzokMHiofH0JahYO2KwVAJRo2sZRcSk/7dgrB/Q1Mn1ZJo+0pX5AVmcSTgKnNTBSrPRJkhDlLBQ0i9r0TwYbzI15Ahg32b9DKZJ1OIh0cGGhtdU1bYZUV6F9IhHtWWQwLYJLSF4kz2BngtzkQqBd9dVd43iud8GD/cgrFgllTvcu7HNT6WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=37EtGnJoRu2YMF/Oy8vFWb6UI3PVDTHFcXTZaIEEaiM=;
 b=l+L/Tclqd3cQ8q7fXPX1TSJrYeBpT+pMJZ+InxePreUaKoIvlH0uuvvTGvJ3dv6H2GmnhTc+9dkwTl8gcM5l2B1zcLkf6eXOH/8zk04nCGLz/R7f1z/LNjy1Ua/gPd9AfpLBP2LhimPAkXuZnDUHLp5U3IynuoUEI7Rv86qIopg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB7147.eurprd04.prod.outlook.com (2603:10a6:10:126::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Wed, 16 Nov
 2022 12:36:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 12:36:24 +0000
Date:   Wed, 16 Nov 2022 14:36:21 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Richie Pearn <richard.pearn@nxp.com>
Subject: Re: =?utf-8?B?5Zue5aSNOiDlm57lpI06IFtSRkMgUEFUQ0ggbmV0LW5leHQg?=
 =?utf-8?Q?2=2F7=5D_net=3A_ethtool?= =?utf-8?Q?=3A?= add support for Frame
 Preemption and MAC Merge layer
Message-ID: <20221116123521.xbtfhkus2eamdm6c@skbuf>
References: <20220819161252.62kx5e7lw3rrvf3m@skbuf>
 <87mtbutr5s.fsf@intel.com>
 <20220907205711.hmvp7nbyyp7c73u5@skbuf>
 <87edwk3wtk.fsf@intel.com>
 <20220910163619.fchn6kwgtvaszgcb@skbuf>
 <87o7viiru6.fsf@intel.com>
 <20220915141417.ru2rdxujcgihmmd5@skbuf>
 <DB8PR04MB57855557502DDC669A470E6FF0019@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20221114154248.57v3gq4g7jwsgfom@skbuf>
 <DB8PR04MB57858C5B15C75CEA34FF5FFAF0049@DB8PR04MB5785.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB8PR04MB57858C5B15C75CEA34FF5FFAF0049@DB8PR04MB5785.eurprd04.prod.outlook.com>
X-ClientProxiedBy: VI1P191CA0012.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:800:1ba::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB8PR04MB7147:EE_
X-MS-Office365-Filtering-Correlation-Id: 2eccd29f-3b5e-409f-d9f4-08dac7cf2c0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LVhFUO4w16LTulWEsupzRm8ssPlSBBpq9DsoBX1TUWIWDybHpzUa/Jl7ZHvkXKoAmXVNS0oA3Q9kN3vOMFrOV3iG+y+voYEVNYcjOcNqUnuA+DSN6wWHy4nsYaEgbJgptEE8MSAA85k/gOc6mem7j6v/Ns0wHywJdda/HLORpv6L+lHWsJdEMOxfIIctisF5W0mGeyYtTH5qmHYzUKJ04xPOu+g5hPlgnnZfBzNu2oweTNKePoGy3lsK7kI7P2liJ6+fS88fNJysPIZ9WNpxbcd2xABQy2e7Eww6NyAR6yys+ZxB+oT3b1gE1N+j1/lIvp/P9wp1RzIpkVfcxpAvpUZkJ0fd1ara/JSp3/nAZ2MERlZh9xyNjB69yX1WdJlj/cnHgxFuzlJWUgdMejyDr0hz1gNvEXvMIgTFKVrO49g6cVG2dTJQiY0fto01XHPIQxl2kO/tJpiJQB+CArV1779qoDpwsMDDIs/XHnvwXqQtXEuCdeOcjoL3gFFFCVVyfgyRRyZE8yLNUiIZ2mtOcNDHSTgZ1Q48aJ37cOwmnlKLb41/jfZz+2AUPTks6F6HOqsO7qVyKufZznW/cki7j0ZGloBM+lrchGPkBzW991QlvqkCiFkkOAck514RoPf1cgKfuux1iMnQ5C/o0PbcLlOXI6YH6e7/CuBC5bKje92RlxGtB+3nibzSiIhGJkeVmBzBV+bRPqDwRBY16tThQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(451199015)(66899015)(186003)(1076003)(26005)(9686003)(6512007)(6506007)(6666004)(33716001)(6486002)(478600001)(224303003)(38100700002)(54906003)(6636002)(5660300002)(8936002)(86362001)(6862004)(41300700001)(83380400001)(66556008)(66476007)(4326008)(66946007)(44832011)(2906002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eitodWMxOWJiNTE2YUdmeXV1NTNlQ0diRVRoWnBXL09SdmJ0YmxFeUFDUnc2?=
 =?utf-8?B?ZC9YYVROUnowYjBWcFFaVnp5VlRJWnBXQkUxMEIyQjZNeFpuS3RtTWtnOFRi?=
 =?utf-8?B?TWs3SGFqWFd6dldVUnF0Qm1MalJKNWlTQnhuVkRuU2JNZEZ4YmlBL0NqaHU2?=
 =?utf-8?B?cUpCUnJ0aWlXT3Frc1J5MUdMaXRXK0JPY2RiOFZiUHVFNkFhOHBDbG1hbjU2?=
 =?utf-8?B?Q1IvWjhseHAzajBvRnBVSk1tVTNkNlNlcklHeDhKQVVHSUVSL2xmbGdjNWM3?=
 =?utf-8?B?RGlERUx6MkZ3SjUwTzFtendESnlIQlhhbUNnN3B0dXViSjR2U0h0T3FPeURn?=
 =?utf-8?B?NXcrVGl4MVZYSEllZlBkV1BhZWQzeXJDZm1WOW5wbmpzb1ZKbXJsc3c2YXV5?=
 =?utf-8?B?bnY2dFF5a2FuRmQxeEQ3Q1RWUkF4ZHg4MkN5WHd0a3hnWHF1MVovRHoyQjQy?=
 =?utf-8?B?TE5sL3drZEtNMURpMG14bk10dGtNWVIwNHZBaFFXUTBZMVNpckkwbmNIakZl?=
 =?utf-8?B?S01OTHkwMjJIWG43cTFmcHQyTmxpT1ZwUDE3dUxFUDNkNlhMWHJtN0dNM0RI?=
 =?utf-8?B?Szl5cG1sSkd6Vyt0UVJZRnRvWkxKVEhaZ0JDL2JpelZpbkdFZFQ1U2pSb2ht?=
 =?utf-8?B?L2V3UVZEL0FhMXFzczI0TkVwaEQ3cFExVzVsZnVmbnZ5T2phQTUycHR3ZDd0?=
 =?utf-8?B?N0pXRXRJYnlSVDY4Rm5xWUVRTlpPa0dRWTFCMnU1YWRBVUlHYy8rRTF2UTlj?=
 =?utf-8?B?dHp4OXVkOUdWZlRhcVQ5V3E2ek1OeGlvcEJFd1JWd1NGZzNOWm5FbkNMTTVl?=
 =?utf-8?B?RkZVNWMxbDFvbFBIVERZSVR4bFNPOHZ0SXpseExrbk9HMG1LMDI5OU9PMlFY?=
 =?utf-8?B?WTl2bTllaUNMZUtNb1NUdFBlNnZITFdMblNNOHpucThZNXJzN0tlSFRRUHk4?=
 =?utf-8?B?RmFpSEtQcHVvQUloaWVPdGhzdUVFNjF5dTFsZkVrVjBVS0Q2YUpmLzBBbWlH?=
 =?utf-8?B?Y1NPZVZldUo0Wkhhdlg3ZFUyN3B5SUdvLy9kdHVLeUhPV2lZUWcwRmRqcG43?=
 =?utf-8?B?K2xMOWRJVnZCdkRuMjAzaGZqV2hkR3JYbHFqbm5uUndRbUh6ZzNMKyszUk1G?=
 =?utf-8?B?UmlIcEtUWW9HVytUcEtsTXZ1a0RTbWdabEtHM3ZJcUdNd09CQVAwUEdEdVRw?=
 =?utf-8?B?cml0cDNEMWd6WGlpTitkempGUmhJSFRIR1JTZThvV0h0RlZZMDgzLzdaYlpU?=
 =?utf-8?B?Z3RyL3YvSFRBaHZ0VzdnSHFmbVpmaEhTcDRXdXJrSkdLQWxmS1A3bVhSVnVG?=
 =?utf-8?B?S0sxNjNIamVoSXJiTGUrd09EOU50djFzY045M0hlM2N0K3hDU3J2Z2tZMENF?=
 =?utf-8?B?SHNBSWNucFYvQ3NweUtxTndrOFVRdmhQeVBOdG12MExxN0xnNTdwZys3MzF4?=
 =?utf-8?B?UFpsdGU3RHVBVnhhWS9IRW1qQmhuK2VVRXIyRnZ1VTIzK2Z2L1I2UGJ3Rys1?=
 =?utf-8?B?OW01SWVaUmVSVkVRZ1BTZDl3U2xtelFOeWlWQloxVDQxaUNPK1pHTEw3MFU0?=
 =?utf-8?B?TE1JWExzNnd5L3Fkb2FQUjNSV2ZJZmU4d1krbGl4ekJPQVdzZjI0VHpadjUv?=
 =?utf-8?B?c29HWXYramE1UkNPZDVFa3NDaFVlTjFoUUFYTEw1UjNHT0FWUFhQUUNmREtr?=
 =?utf-8?B?UWF6MFRyR3hvRnRqbzBpR2VJZUljalgrR1oxSFo3SGU2TW1pZzFSTExXN3Y5?=
 =?utf-8?B?VTdtNm5YYnpPckg1OEFRTHNQelNId2ttYzNqNjlYU0RidFhiWHRpOVBTRHM0?=
 =?utf-8?B?UlkvT01tMzRjZTN2ZkYrMFgxeG5yQUg0YmZQYXVWNWgwaS9DTTZIQkhZb1FI?=
 =?utf-8?B?Y1NOSFlxYms0NVcwTllQZzhhNVdMSEUwazNjUS80N2NMQm1XejZqeTZ3MWtZ?=
 =?utf-8?B?Ykg0U2dkeGhOazlnSWZHV0pCRDVtd3B0WC9lZXcyQVNqMGlpN2l1dlRhR0pH?=
 =?utf-8?B?cENJbkJMdS9ZRUpCNkJYRy9CaHRUaUdicHZnbHZRd05vcHlyWHdubVlFVW1E?=
 =?utf-8?B?RUZad1Z2RDZNRGgvdGJRNHptVEloUkl3TiswYWlzRlJkVjVpTm5PTm1FaTNC?=
 =?utf-8?B?SjVMYW9JeENRRmk1d01GS0xSMkxuNUJTUXA5dTVwVEpqUUlGWFMzQzYrT2hU?=
 =?utf-8?B?a0E9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eccd29f-3b5e-409f-d9f4-08dac7cf2c0b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 12:36:23.9978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PQ0lPic0cKLOWDWmkrLSL5GgXJ/i7nzaufu5+U/0i3+GvZxrLkAg/imvI1ApUGiI/nS6d9ESlsGiKW7t0OWa+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7147
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xiaoliang,

On Tue, Nov 15, 2022 at 05:01:24AM +0200, Xiaoliang Yang wrote:
> Yes, I know that "Enable" and "activate" are different things. I mean that if we
> want to enable the next lldp exchange verification process, we need to enable
> it but not let the MAC merge layer working until lldp verify successfully.
> There are two verification procedure, one is LLDP verification, based on chapter
> "99.4.2 Determining that the link partner supports preemption" of 802.3 spec.
> This need lldp exchange and ensure preemption is enabled on remote port, and
> this verification doesn’t have parameter to enable/disable it. I just want to add
> this feature.

Why? The mechanism to enable/disable the MAC Merge layer is the ETHTOOL_A_MM_ENABLED
netlink attribute which is settable.

To the kernel, it doesn't matter if ethtool (the program) or openlldp
sets ETHTOOL_A_MM_ENABLED.

> Another is SMD-r/v verification, this is hardware verification and
> already has "verify_disable" to enable/disable it.
> 
> Or we can enable by default through LLDP. That don’t need a new "active"
> parameter. Once the LLDP application has verified that remote port supports
> preemption, it will enable preemption on local port, and tell remote port to
> enable it.

IIUC, it cannot "tell" the link partner to enable preemption. It can
just advertise the following in a subsequent TLV:

Table 79–8—Additional Ethernet capabilities

Bit 0 (preemption capability support) - supported/not supported
Bit 1 (preemption capability status) - enabled/not enabled
Bit 2 (preemption capability active) - active/not active
Bits 4:3 (additional fragment size) - A 2-bit integer value indicating,
in units of 64 octets, the minimum number of octets over 64 octets
required in non-final fragments by the receiver

The only thing we can do, is if the link partner sets Bit 0 to true, to
generate a ETHTOOL_MSG_MM_SET netlink message with ETHTOOL_A_MM_ENABLED
set to true.

We _cannot_ wait for the link partner to set Bit 1 to true, because, if
it's the same implementation as us, nothing will work, we will both wait
for each other...

So either the link partner enables preemption too, as a result of us
advertising a TLV with Bit 0 set, and things eventually work, or the
link partner doesn't enable preemption even though both ends support it.
In that case, preemption doesn't work (and this is also visible in the
TLVs sent by the link partner - Bit 1 and Bit 2 remain zero).

If the SMD-V/SMD-R handshake is enabled locally (ETHTOOL_A_MM_VERIFY_DISABLE
is false), we can also detect that by the fact that the link partner
will not respond with a SMD-R to our SMD-V. So, even if we will set Bit 1
(corresponds to ETHTOOL_A_MM_ENABLED in the ETHTOOL_MSG_MM_GET message)
to true, Bit 2 (corresponding to ETHTOOL_A_MM_ACTIVE in the GET message)
will still remain unset. Otherwise, the condition will remain undetected,
and we will report Bit 2 (active) as true (which it is - verification is
disabled after all).

> If we use ethtool to enable preemption, the preemption will be force
> enabled without LLDP verification.

Yup. I consider that within the expected parameters of the game, no?

> > In turn, LLDP does not control whether verification is used or not. So, from the
> > perspective of the LLDP daemon, you can't "enable" but "not activate"
> > preemption.
> Yes, LLDP does not control whether hardware verification is used or not. Maybe I
> shouldn't use the word "active", I mean preemption can't be working before LLDP
> verification, even though it's enabled by ethtool.

I don't understand this. Why can't preemption work without LLDP
verification? My understanding is that LLDP is just an automated way of
maximizing the enabled feature set depending on what the link partner
advertises as supported. But the same feature set can be force-enabled
manually, if there is prior knowledge that the link partner can do it.
I think of it as a software autoneg, I might be wrong, I don't have too
much XP with LLDP. That's exactly what ethtool (the program, not the
kernel interface) is for - to be able to force settings.

> > And I wouldn't expect the LLDP flow to require use of ethtool.
> If LLDP application can’t require to use ethtool driver, how to enable the preemption
> after LLDP verification?

No, I mean the LLDP flow doesn't require use of ethtool the program, not
ethtool the kernel netlink interface. Of course it requires the latter.

> > And I think that enabling preemption at step 1 is too early. Why enable it, if we
> > don't know if the link partner supports it?
> Same as mentioned above. Enabling at step 1 does not actually enable preemption,
> it means enable the LLDP verification.

Nope. LLDP verification is no more than a user space program that
automates something that can also be done manually, using ethtool the
program. No special netlink messages for LLDP.

> > So those who enable verification should get a response from those who don't
> > enable it, and those who don't enable verification don't cause the link partners
> > who do enable it to fail their own verification.
> The hardware may not obey this rule. I have tested on LS1028a and i.mx8mp boards,
> The verification needs to be enabled at the same time for link partners. So it needs
> LLDP verification, and let LLDP application to enable both partner ports at the same
> time(The hardware verify three times, and each verify time is 10ms in default).

I think the imx8mp has the same EQOS block as the S32G GMAC, right?
If so, I might try experimenting a bit on the S32G linked to LS1028A,
to see exactly what you're talking about.

Keep in mind that hardware quirks don't mean much to what the user space
flow should be. The kernel should deal with quirks. For example, on enetc,
the MAC merge layer must be manually disabled and re-enabled on each
link up/down event by the kernel driver. Otherwise the verification
state machine remains FAILED, as you seem to say. But that changes
exactly nothing in terms of the LLDP flow - because as you say, the
hardware SMD-R/SMD-V verification state machine which you talk about is
independent of LLDP.

> > The only thing to agree on is this: if the link partner supports preemption, and
> > you support preemption, then how does the LLDP daemon decide whether to
> > actually *enable* preemption? My assumption is that it's fine to
> > unconditionally enable it as long as it's supported.
> > No configuration or user override is needed.
> Yes, I also consider this way. Enable the preemption once LLDP exchange ensure
> that both partner support it. But how to enable preemption via LLDP daemon?
> I tried to use the ioctl API of ethtool to enable preemption. Do you have any
> suggestion?

Yeah, see above. The ethtool ioctl is dead and it's not coming back, see ETHTOOL_A_MM_ENABLED.
I wish I could come back to this patch set sooner, but I'm really deadlocked
with some other stuff I need to do this week. Sorry.
