Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB0C344B48
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhCVQ1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:27:53 -0400
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:36321
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231689AbhCVQ1g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 12:27:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xth9xgdrFYA4xB797u+cdbzDAIEONOlj55my1a4tGdZhKd18AVbr/ypduJPPYInWiJVeht618rNTxmsWdYHXgyn5tANSqBtZM0v0ETUQGHMQdzcsmSwEh7idEA9Rc0ebT6oXJrxt5uCKl9zRqNI33bLNI+fsxPuLCiOIx35aukkRmVCE76rMXDJPeFt7B7UaTOVr9fmisPudOyDIxfo72iVF/MMxoU7SF4HealcFhbftvZBlSNUR5atPpWHBL50aopOLQLyoG3LxZTD0FJp+KUJt+7VJpXZMs325eH7nE//VcLr7AZHcu9ILU91WYbmNCZ86x/DZP4Ch/LhHWn5zxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GrzTnA40WBABDFMmMfptzlnoOkGVs0lYXFNp+i5SXtI=;
 b=NTtQgKw77oxbAmeU9chK4iiaDKrfosnhryoyjPxZ7jC1pPyX6Hb6pfVbnmdqB0qHmSFmNwLtjVaRVqA5NCwSuCVSbYxsRzBzS6kl1UI63s7umUUkfFKy6cltAq9zp8dZzwYdZ2k9qb08rN2BIzT4/XSwqIR36johEUUYg/FInm/EwIlcBB/pF4aNPAf/fCRgAKMcJBs0UWcz6RrU32Gn6VEXComVPb2B07YtxClyFX5hVlToElcD2oq0iJGiBbL83OnKZ3zeOt/SGKKOc6vI1Adx2ORSwBeAfhSnqu/5QIfORQse3faIsz1AU6koca7An/iLICnb5oBVNbiqwvdk9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GrzTnA40WBABDFMmMfptzlnoOkGVs0lYXFNp+i5SXtI=;
 b=Jf+2NDdeT4LZTQOp/iRcAtd1R8nS/hgnieXj6QQUPEE0fArlxbo3TNPpxIvg3rdmXPdLm5nO+sTuPOf30pA7+nOiTdSBMVhBOPxx5GRZwRo8vavRQ43j8hIQfbDbRmbSaeBi0CKZevSyEwF21JGllMJ1mh577Pam+Viimr0mtgGQsD+JRPYU78l8X8zWm+bnt6zQWFg9bW/wLFnPM6sHJijwZb6r2G8mdYYTWIZgCv6NHga1dnC2ioykuHTceHy6yb6P42OILihBlQrgmvjuf19/H2IwYLIWRY0I0p9jcx2c/7Fug9CnuVAKzhSBQBtpAoepO8DUqU0+2bKofD/vDw==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB3242.namprd12.prod.outlook.com (2603:10b6:5:189::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 16:27:35 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3955.027; Mon, 22 Mar 2021
 16:27:35 +0000
Subject: Re: [PATCH v3 net-next 00/12] Better support for sandwiched LAGs with
 bridge and DSA
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Ivan Vecera <ivecera@redhat.com>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210320223448.2452869-1-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <3230fb8e-eb75-acc1-e53c-c2525e022370@nvidia.com>
Date:   Mon, 22 Mar 2021 18:27:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210320223448.2452869-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZRAP278CA0011.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::21) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.38] (213.179.129.39) by ZRAP278CA0011.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 16:27:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e949c501-6c3c-4c70-bb67-08d8ed4f6647
X-MS-TrafficTypeDiagnostic: DM6PR12MB3242:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB32429BF5837435FCC80BE486DF659@DM6PR12MB3242.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AadKPVA8CKz82WBBp4T3NKCQ+ZPoYm7MNj44M6D17xrc/IRMJWA+IfsN52a/KcCWFFGZoXd3+lIDQ2bfddfeKVvLfVOCabiJgTreZasFkqK8QsyrYEGCyXkoz2bs/dFGe+Do8I5q8Wowh79mjsZ4780dLvQ9obGSDbIctp7xFZTzl4rQD40gb/HmxoTbEjfj4oiCKB1zu13eQ31QjZd0fR0A/UiEbAKgXch/ksddQBb2lDdFdc4lokAoQvVi6ZyO3nTvKAladm+pUPcwfvwVQ4pRxhNTcqIv9kcMMjg0T336pqqkheICreJcbayMHcU7kvNE7RhHsf+kRgm15jHOLh3pegKuqxYo9/N/RGBJssVvk4VLq3G78pPxETssNSA+IIg6lVPrEE4VZrSXfgkehlq+Qf4NZxg4E0SmAFXIajBH/Y506JOR0x8UXn9Ejg4xOE80kwrJxD5bv7nILMPJ7fOX+s8LDOqnGenKiF3/tj3iZRF+nnd6WLlHBFO+WYX5IOBecSWwXWE7GUwG9O/C+qSTnmaSN3hcRmD0OzOGI3BCzTekXoV5xy8Tr/rkqOcXC4V49nsr8cIlojIlYwjRupxZSeS18BT7QhqYFH1gqrJXBNAy6m2CkiHzHKeSMJgUXGDhn1zjqNADwFiAVMlv1lcz38gxRyLsTgmjTVrEF5r+ybwde8Go0uCguKrgAeJHPgWX2cxbV32w/IOwrrFOFi81XkDB09ftzGLNvCQiq8o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(7416002)(31696002)(110136005)(83380400001)(66574015)(16526019)(53546011)(186003)(4326008)(6486002)(5660300002)(54906003)(66946007)(66556008)(66476007)(26005)(8676002)(956004)(38100700001)(2906002)(478600001)(8936002)(6666004)(36756003)(2616005)(31686004)(16576012)(86362001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ei9MYjRlVnA5L0ttbk4wN0IvK3NqblJ3azZDekxmR1JCMXJDZTJBUzBoeFda?=
 =?utf-8?B?cFhKZGdEN0dSNXdDUDFHdjltRm14OWxwRG9PZFFoWjBGblJtVFZkOVZKTEJV?=
 =?utf-8?B?VkFRNVZITDgxY3RHNEpETzZvUkgyNmxIcm9PVElRM3o4SEtwL2JTZWVEVnRT?=
 =?utf-8?B?UThJLzVFL0FxcDl6RjJqeTN6MXhsdzBJMWZXYmRodzluWk05YkRDOGtHZjZ3?=
 =?utf-8?B?cFlRRHcxc2FOZVFRVnhjY1FsQVRQK1FuSTZpWmFsZnN6cmthZDUvT25keTFX?=
 =?utf-8?B?THBqNTVPQTNGQzZZdFRxUCtReWQ0b0U0aDA0L2FlRW9sZGQ1c2E4ZDlzYll5?=
 =?utf-8?B?TG9ZRGVFNStWVXVST0RqZWxBUVovQ2s3TUJSUVdJWHJKb1FKekZrRjk4M3Mw?=
 =?utf-8?B?MkYzY1FyRG9hWTQrYWc5Slp1MjRSRG5objBvblVJWTJvOFFDbzRrUUpRdFNJ?=
 =?utf-8?B?bkhsVlBYZjJTT2laMFg0WFJUOGJhRUJrcVVrbTljZDZsQXE0VFRPdEFhSkdW?=
 =?utf-8?B?RExGTjBoaXNENk5mWDdKeEVVbTY0Sitsd05oRGxIWGtzcFljVmZaKzU5WCtw?=
 =?utf-8?B?LzFXL1dYN1pOcEY5MDNNUHBVbWFjMUpHbVZGTzlTZndlZ2tFMFAwWW1aLytu?=
 =?utf-8?B?azNHbVhYVGs3NSsrTkxHMzVPandzYTNSVm81TDc2RDluOElIV1Y0V3d1QzA3?=
 =?utf-8?B?RXlXb1BkbVNFQ2xtc2t2bVJNQzc3U3lDRXZIcUhsbS9MaXJjenZvWm90aHc4?=
 =?utf-8?B?cHJPQVQ3QkdmcXNrMmU4MFB5a2kvTStSL0pyaG85UjBJWldrOU9ydm9Ec3dv?=
 =?utf-8?B?RDJLS3NocU94SFVCUFRzd25yNmlhSUFqdFpMWEYzOXRWVVF4Z09KSCt4L3NZ?=
 =?utf-8?B?bzlXZHltTFNJZVlDOE53Z0NWSWZwVmkydmNIajVXNDFVZGs4SCtIL21UT1Q1?=
 =?utf-8?B?MDgwRGl6WGRKRGVGalZyRnB4YXc2eUhpcUFXYnRsSXY5VFlIUnB1WTU2SllC?=
 =?utf-8?B?RG9SRGlETmNvQU5jYkk5b212YmhWZVBIamlQWFpQVk81dXd4cGhXQU5RNDRm?=
 =?utf-8?B?VlhBUWI5TGdLdjgzT29RQ2RkNlBDV00vb0o4cGFzR0NVZnlvOWJ2U2J0bHFT?=
 =?utf-8?B?bktHQlhhRVY4M2l5MFZmUVJoS2k3L2VhM1g4VS9tcmtqRVl1OGxwVGtTazli?=
 =?utf-8?B?ODFrOURJWnJIU2FWQzFsNjY0SmFoZVNPM1hxR0NMbGR1dnoyditLSWhMSm0w?=
 =?utf-8?B?U1JBWDUvcnJHWHd3MDkxeUpEYVRiaEhHV29zbW1kVHoxbGZDMUtNcXVsaFpl?=
 =?utf-8?B?d09iaTZSQ2NEWGdHTVZsdkUvTXNZb29YQk5DMEhxRWZIT3FpRGhOVUlCYU9j?=
 =?utf-8?B?N0VydFlzckxJMHRGVUo5Skw5S25yNDF3UkxQdnpnNk5OYnJkYkhnYTdVRjUx?=
 =?utf-8?B?dGFLWEtSemVGcDhBZERWUDRPRFpFNDYyZ1oyOVhsckFyTVZmOWtBMFFiR2tL?=
 =?utf-8?B?RTJJWnN1dDk2TmRRS1A1NThmZUM2MUFRM3E5VU9rbW4wRCtxYjl2M0NSYzVJ?=
 =?utf-8?B?d01FcG1xbXl4YzRzM1piYm92V2oxZ095clphV1JFZWNFcm5mWTRkRlFUOTNq?=
 =?utf-8?B?dkNiNlBIVlU0Qk1hY0Qzem9Uc2YyNjQyYU92S3hTQ1Z6c3M3Qy9YSEZTdVYx?=
 =?utf-8?B?RDY5T2xSbzROaWVrTEkwb24vc1p2bkNUNjZtcE15c0JLNVByY2dJRFRNam1L?=
 =?utf-8?Q?1j2ZWFFK1mGdHud1O7wQWpPWgPZY9DqT7sQdxPL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e949c501-6c3c-4c70-bb67-08d8ed4f6647
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 16:27:34.9829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LmdwukvAnpB7DYXMhlzSDTHqG6r9S1vu7gJYWqxqOJzjDqhawkFDRJKYA5aSqbNEe6soYAxWN/fwiQWdwnXARg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3242
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/03/2021 00:34, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The objective of this series is to make LAG uppers on top of switchdev
> ports work regardless of which order we link interfaces to their masters
> (first make the port join the LAG, then the LAG join the bridge, or the
> other way around).
> 
> There was a design decision to be made in patches 2-4 on whether we
> should adopt the "push" model (which attempts to solve the problem
> centrally, in the bridge layer) where the driver just calls:
> 
>   switchdev_bridge_port_offloaded(brport_dev,
>                                   &atomic_notifier_block,
>                                   &blocking_notifier_block,
>                                   extack);
> 
> and the bridge just replays the entire collection of switchdev port
> attributes and objects that it has, in some predefined order and with
> some predefined error handling logic;
> 
> 
> or the "pull" model (which attempts to solve the problem by giving the
> driver the rope to hang itself), where the driver, apart from calling:
> 
>   switchdev_bridge_port_offloaded(brport_dev, extack);
> 
> has the task of "dumpster diving" (as Tobias puts it) through the bridge
> attributes and objects by itself, by calling:
> 
>   - br_vlan_replay
>   - br_fdb_replay
>   - br_mdb_replay
>   - br_vlan_enabled
>   - br_port_flag_is_set
>   - br_port_get_stp_state
>   - br_multicast_router
>   - br_get_ageing_time
> 
> (not necessarily all of them, and not necessarily in this order, and
> with driver-defined error handling).
> 
> Even though I'm not in love myself with the "pull" model, I chose it
> because there is a fundamental trick with replaying switchdev events
> like this:
> 
> ip link add br0 type bridge
> ip link add bond0 type bond
> ip link set bond0 master br0
> ip link set swp0 master bond0 <- this will replay the objects once for
>                                  the bond0 bridge port, and the swp0
>                                  switchdev port will process them
> ip link set swp1 master bond0 <- this will replay the objects again for
>                                  the bond0 bridge port, and the swp1
>                                  switchdev port will see them, but swp0
>                                  will see them for the second time now
> 
> Basically I believe that it is implementation defined whether the driver
> wants to error out on switchdev objects seen twice on a port, and the
> bridge should not enforce a certain model for that. For example, for FDB
> entries added to a bonding interface, the underling switchdev driver
> might have an abstraction for just that: an FDB entry pointing towards a
> logical (as opposed to physical) port. So when the second port joins the
> bridge, it doesn't realy need to replay FDB entries, since there is
> already at least one hardware port which has been receiving those
> events, and the FDB entries don't need to be added a second time to the
> same logical port.
> In the other corner, we have the drivers that handle switchdev port
> attributes on a LAG as individual switchdev port attributes on physical
> ports (example: VLAN filtering). In fact, the switchdev_handle_port_attr_set
> helper facilitates this: it is a fan-out from a single orig_dev towards
> multiple lowers that pass the check_cb().
> But that's the point: switchdev_handle_port_attr_set is just a helper
> which the driver _opts_ to use. The bridge can't enforce the "push"
> model, because that would assume that all drivers handle port attributes
> in the same way, which is probably false.
> 
> For this reason, I preferred to go with the "pull" mode for this patch
> set. Just to see how bad it is for other switchdev drivers to copy-paste
> this logic, I added the pull support to ocelot too, and I think it's
> pretty manageable.
> 
> Vladimir Oltean (12):
>   net: dsa: call dsa_port_bridge_join when joining a LAG that is already
>     in a bridge
>   net: dsa: pass extack to dsa_port_{bridge,lag}_join
>   net: dsa: inherit the actual bridge port flags at join time
>   net: dsa: sync up with bridge port's STP state when joining
>   net: dsa: sync up VLAN filtering state when joining the bridge
>   net: dsa: sync multicast router state when joining the bridge
>   net: dsa: sync ageing time when joining the bridge
>   net: dsa: replay port and host-joined mdb entries when joining the
>     bridge
>   net: dsa: replay port and local fdb entries when joining the bridge
>   net: dsa: replay VLANs installed on port when joining the bridge
>   net: ocelot: call ocelot_netdevice_bridge_join when joining a bridged
>     LAG
>   net: ocelot: replay switchdev events when joining bridge
> 
>  drivers/net/dsa/ocelot/felix.c         |   4 +-
>  drivers/net/ethernet/mscc/ocelot.c     |  18 +--
>  drivers/net/ethernet/mscc/ocelot_net.c | 208 +++++++++++++++++++++----
>  include/linux/if_bridge.h              |  40 +++++
>  include/net/switchdev.h                |   1 +
>  include/soc/mscc/ocelot.h              |   6 +-
>  net/bridge/br_fdb.c                    |  52 +++++++
>  net/bridge/br_mdb.c                    |  84 ++++++++++
>  net/bridge/br_stp.c                    |  27 ++++
>  net/bridge/br_vlan.c                   |  71 +++++++++
>  net/dsa/dsa_priv.h                     |   9 +-
>  net/dsa/port.c                         | 203 ++++++++++++++++++------
>  net/dsa/slave.c                        |  11 +-
>  13 files changed, 631 insertions(+), 103 deletions(-)
> 

Hi Vladimir,
Please pull all of the new bridge code into separate patches with the proper
bridge subsystems tagged in the subject.
I'll review the bridge changes in a minute.

Thanks,
 Nik
