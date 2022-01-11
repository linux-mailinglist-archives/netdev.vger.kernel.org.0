Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7109A48A511
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243671AbiAKB33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:29:29 -0500
Received: from mail-eus2azon11021017.outbound.protection.outlook.com ([52.101.57.17]:35907
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230204AbiAKB32 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 20:29:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NEv16JccNhBvL6JXBYX5ncQGVk40AoesnNvoYLpPAt/H9BlOROAT5yGrjW5Qv+G0priIOOzZjPXJTOQbFqoYoPc/+iqWTHrUaQAq6SEqTZNeAeZkOxtEaOMVR9KaxCLNybAFsd+hXTeMQvHGEH8EFVxvrN2IWEzNz9wuWHMr0eTaCRneDPAq1KzTi6Ia8yFAIjIofM829SPqwqBkrqdtKqgRSpfyF8FzGw5LCd1ooGF3wgpTPbLRGaY4y2mJizDibjAYFWJt8ctCKCBy3qVpKM21Z7dMB9tIfawhCIc6Aba9bv9xVYjviOltgyrvAnQ1jBtRNrO+Ywh+NTDzVCGmqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MmmHF7sAA9CYD4z5CJeDtkcNuM3XM7RUpLCUiJXPtmM=;
 b=CYW+ki+FTcVjPXbhxZ7rlh6tALQGrCTJjSuOPr8EGQnNOvHHVie8Dx7j+/R+01RHw71ygrSwi76Rs7LCPIirM+5bYJu2E1sGlb01siEhRE7+8/InNx76vUILQ6U5ZVqYEvgQ5XOVHFByrK3y+crDGlrylc1WqyN1yF4401rfvPcsRZXd76XKXftutnf9Z2wIpPm78fmLwoomnKFh5tiSch/nuERMW2tHsqeCkzTs+Cj2aN6lCcXHNaM0cYUn8yyyNMAsS+MR5fUzUB0qlWVXv5cxDANfHxW1p+iaIOmMRqkDbUiYFnuJ6jYaFcPP8+fQKGExic9zDV71Rj46tnM7dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MmmHF7sAA9CYD4z5CJeDtkcNuM3XM7RUpLCUiJXPtmM=;
 b=VbJ4G/Cv1XSwqXFLGuEyrOviX3O017Or8W3nZtnt6IAUWdNQR0VPe61KBp5vLpXOVSBDm9ihdPXarLiwDb/ezXx7JygRON1Mykcdo1s+qCLkGqW+/FdX8g7ur4l00PNAv4BOd1VSgWZ0JQHn+IdPctZiGZelb8vk1TmsSWLeUMY=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by SN4PR2101MB0736.namprd21.prod.outlook.com (2603:10b6:803:51::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.5; Tue, 11 Jan
 2022 01:29:25 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::dde:bbe6:4c90:5c]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::dde:bbe6:4c90:5c%5]) with mapi id 15.20.4909.001; Tue, 11 Jan 2022
 01:29:25 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Stephen Hemminger <sthemmin@microsoft.com>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        Steven French <Steven.French@microsoft.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
CC:     Long Li <longli@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Find no outgoing routing table entry for CIFS reconnect?
Thread-Topic: Find no outgoing routing table entry for CIFS reconnect?
Thread-Index: AdgGilhdw5E0Suv2QruSRnhqw44Iaw==
Date:   Tue, 11 Jan 2022 01:29:25 +0000
Message-ID: <BYAPR21MB1270EB03413A9CDDD787D673BF519@BYAPR21MB1270.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=60b94a78-7319-4ee3-9eb3-3ce5b4ab4d99;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-01-11T01:26:41Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa361aaa-ace4-48fc-4254-08d9d4a1cd8d
x-ms-traffictypediagnostic: SN4PR2101MB0736:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <SN4PR2101MB073671713D5ADE7F63EDFE75BF519@SN4PR2101MB0736.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wZ348A7Sz+ot2KJp4GxbSv6M4sWGg4iF+5HXq1Wk/5Wl344F6fp6mCeeex+9IJVQSPCwRxmo0p8jWGdDxi+yHhtWvHt91qJwTdhaHBdcAEjSuLJzjrXgp6XCEZ4zRQFvW05TI9bvHKXi1ywqGI99IM7gChJGUc75cPjLRGzymVbF7tT9fQDC0bWrZoe9/guwGR+ois7T+uQbQNompFqdr4MQQUQgcOp0zV+dX0hbiSqtjimE569NppjesZxcsMUCYdriP4kNLYFYZsO/NBHRPeEp5AUsgkjnfm8SDfGrdNnFMnqNpxufbPKA8e8dg5yIis+F3+MjRPXzx5wSbyorbv/2wDhlaNmgT+P3EM8Q1Km+QTCPvc3Fdq/2lIx4ICfEOLKuZkrpjqAjoc4Kz/jwBAICr2Q4hImmS8wdxTaVCxlSZ8ohMTy5xJm9xBQpSFSQpakARlyeL5zYMNWMfcnC1eBvr2Si+sQXMHnfKY1bNHTzyBUh0JZVdoOfDGqmI6GVaCd8S6wX9MILLYAFEp5Sl7hxqU73gYjViriiG7rZPpo06X+Tk7McjjvP388tmehrj3mdO8iTW5f+wBVvDRXSrP5bj+O+bBA1LXVjEz/sy8U6moE97NL6wtnXDMeycH55x45N9hhwGajZBhfZvelrqxjiWv/Ok+J2HAxFy2nkTo7QxeRHoyc2TMPK4ndi0sqI62yBDxXGI8ujlBZaQ7bySVt9ZpJDSw2Z54E3zS6VkSUzwxGl2BC3pLR9mM/FXvASs1G/nYFDh/T4Uwg2e47qI/Oe5Ts6sjZyZJX6TqMTmoyNeEMtOfUhJN8yrZKflnZGBhsursz0hzsQ+Z7wOwWPjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(55016003)(38070700005)(86362001)(2906002)(83380400001)(54906003)(316002)(76116006)(10290500003)(186003)(38100700002)(508600001)(26005)(8990500004)(122000001)(82960400001)(82950400001)(4326008)(66476007)(6506007)(66556008)(64756008)(66946007)(110136005)(8936002)(66446008)(7696005)(71200400001)(52536014)(8676002)(5660300002)(33656002)(450100002)(9686003)(966005)(491001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gfUp1oaUwghN0Ylkt8uTf8pfqOxkHIH2AhZjCeI0B8SSqqaOWmp5pfei2/FV?=
 =?us-ascii?Q?0ETFSjlhljWNSsu1mcQZTSPxYNRiaBamGSv2JmeqJwUxWcDzNIeS5FjjFj9K?=
 =?us-ascii?Q?0oxHUSPCH/JT5xwh1G1fnlRVck+2mXd1AWOPJ6C3lzJBbZbGV4Tg/deq4VjU?=
 =?us-ascii?Q?l+CzJLypb94685rcjLw+GzmWfHjVH8K4fsjnywgWeBrG9b1uH/yHR5pJfJIi?=
 =?us-ascii?Q?6+7x0FvT3959APY33NW5cBr7+o7bJ9zBKF7sr/Hb95H5kgmeW2p+KkYn62z5?=
 =?us-ascii?Q?3eYcKz/AgRmxxK7yYKRA6iLOLCHjrqK5DLz6lKWUNqa877+qkttj3wDrkmLo?=
 =?us-ascii?Q?uhJG+hS04bD6RfRx569eYRPDyG2G7S+Ey0/+lNQmhAeUGRoDFjWWsrQP060T?=
 =?us-ascii?Q?LQGojoV7n30xDjdrxZUjIz2oU0TxQ2VpXWgcDMqWxj1IwteIEsSOIKl6RMqQ?=
 =?us-ascii?Q?O5QX98I+hlG4U3L4KgsHv2eotH4EgImcUntpr7xr0a/Hf/8rnhLK5hunoChF?=
 =?us-ascii?Q?0AxKlJ961gm56F31KeJ+H/2OVDsu5qvL4GrhwKhMTC6eCGpDDEklvnO/iiSQ?=
 =?us-ascii?Q?4m/MFM22AX1bVTsG03DtWGg5tpqIc1ZBECiBADxPqrzrKfiU4xGPsqMBRotZ?=
 =?us-ascii?Q?zCMS0S+Dy4mLQBhzv21owhz+H3fQY7WB3GNTz6CZGy0Z14wpTk/z3trTZSv3?=
 =?us-ascii?Q?rgzoQI1Lf+UAsH1MjPEn3C1V/USMRzAWrt3JFN7g3o8Q4dp16Zg28kZ7yh9Q?=
 =?us-ascii?Q?RoRkpU+qdJIdAebdnFU84Z0eRw68GTW+0Jibg46BFDFXQXqaESZMkHM0Mt35?=
 =?us-ascii?Q?zYwjhXXzCXRYZsGyM3ljL2R8OaTDsN4LbJ2Km9lWO9Y2UkEMAPzqxN/Hnyfa?=
 =?us-ascii?Q?rVxaeI6H/3fEsaSCaPlQeB77ufeiN9M/5UC9FU6EZkVAFmgtMARAuT3iyxHa?=
 =?us-ascii?Q?mJ/RSCpy79sPOJEeOfuiIxyW8GvILulRE4N+Z23X6Cb+duMsdMEepQ0DHbhe?=
 =?us-ascii?Q?hDH/BMopxVbpM1kfXQivXuGDoRTmr+I50VHTENI/Aa+ZPUhcNHheTXg3+EN0?=
 =?us-ascii?Q?dYFHt9MTs3ZD+ArqWeIO3ciUrQSuuh3obpOh9qVSAbgvOASythcR8HnIunNP?=
 =?us-ascii?Q?NAfiSpmIyKAMv8C0RFF8g8swYr+Jl/Tg2qtMigUwVoo6Drn/QlFbgPgiwpbC?=
 =?us-ascii?Q?FBwSNoycQUAv4Mycl8mnVqTOj5pngcT1a+sSbR5U8MUO2iJUk/i9zkUeTXhc?=
 =?us-ascii?Q?slazDuyv9p88gyC1iMCyPlhEOHgiE/6NzaIuQdGH9v62q5JhpKEa0LA+sBcp?=
 =?us-ascii?Q?Y875lpjPZrUeYLMHWof5hCiuZa8Qn7gr50ejOcMQ/HwQq46fjUpr5/vrQSi2?=
 =?us-ascii?Q?wnwoNrX63IOcTzj424ouB6RbBSeDQtYVqi3DFk9Kk50HYlYv5vFZHeGVVTFD?=
 =?us-ascii?Q?ifiUezANVyyYZa+hsrT8HtAad5o5kV64v+g5Dsqf7c0GXvxKsK9q8zG6Yobd?=
 =?us-ascii?Q?OkizxzcjteZQdz0DAbtY5EW2+dLeGiM87wqoUFQJGCGF5sQ295ar/uf+NgoY?=
 =?us-ascii?Q?WECWLBP/m1Bkv9/p82V4o1PsMRYll6eUbVMfVIwYnajf01AKB4SbT8bH3lTm?=
 =?us-ascii?Q?vnbtRvufc0R/QFgEf/sdPHs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa361aaa-ace4-48fc-4254-08d9d4a1cd8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 01:29:25.0695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aZcsT8CUj7Mxg9Jatg11FMthtIfR9lGfzYQBFZ4pZOEM4ZMH11YNPma7o4dA3djWDGKRHDFqpG74uhclRkxZgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR2101MB0736
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, all,
I'm investigating a Linux networking issue: inside a Linux container, the
Linux network stack fails to find an outgoing routing table entry for the
CIFS module's TCP request; however, inside the same container, I'm able to
connect to the same CIFS server by "telnet cifs-server 445"! I think the
kernel CIFS module and the userspace "telnet" program should share the
same network namespace in the same container, so they should be using the
same routing table? It's unclear why the CIFS-initiated outgoing TCP
connect fails to find a routing table entry. Anyone happens to know about
such a bug?

Here I'm unable to reproduce the issue at will, but from time to time some
container suddenly starts to hit the issue after it has been working fine
several days, and the user starts to complain that a mounted CIFS folder
becomes inaccessible due to -ENETUNREACH (-101), and only reboot
can work around the issue temporarily, and the issue might re-occur later.

Here the VM kernel is 5.4.0-1064-azure [1], and I don't know if the mainlin=
e
has the issue or not. Here I debugged the issue using ftrace and bpftrace
in a VM/container that was showing the issue, and the -ENETUNREACH
error happens this way:

tcp_v4_connect
	ip_route_connect
		__ip_route_output_key
			ip_route_output_key_hash
				ip_route_output_key_hash_rcu
					fib_lookup


static inline int fib_lookup(struct net *net, const struct flowi4 *flp,
                             struct fib_result *res, unsigned int flags)
{
        struct fib_table *tb;
        int err =3D -ENETUNREACH;

        rcu_read_lock();

        tb =3D fib_get_table(net, RT_TABLE_MAIN);
        if (tb)
                err =3D fib_table_lookup(tb, flp, res, flags | FIB_LOOKUP_N=
OREF);

        if (err =3D=3D -EAGAIN)
                err =3D -ENETUNREACH;

        rcu_read_unlock();

        return err;
}

The above fib_table_lookup() returne -EAGAIN (-11), which is converted
to -ENETUNREACH.

The code of fib_table_lookup() is complicated [1] and the pre-defined
tracepoint in the function doesn't reveal why the cifs kernel thread fails
to find an outgoing routing table entry while the telnet program can find
the entry:

cifsd-4809 [001] .... 94040.997416: fib_table_lookup: table 254 oif 0 iif 1=
 proto 6 0.0.0.0/0 -> 10.10.166.38/445 tos 0 scope 0 flags 0 =3D=3D> dev - =
gw 0.0.0.0/:: err -11
telnet-4195 [003] .... 94041.005634: fib_table_lookup: table 254 oif 0 iif =
1 proto 6 0.0.0.0/0 -> 10.10.166.38/445 tos 16 scope 0 flags 0 =3D=3D> dev =
eth0 gw 10.133.162.1/:: err 0
telnet-4195 [003] .... 94041.005638: fib_table_lookup: table 254 oif 0 iif =
1 proto 6 10.133.162.32/0 -> 10.10.166.38/445 tos 16 scope 0 flags 0 =3D=3D=
> dev eth0 gw 10.133.162.1/:: err 0
telnet-4195 [003] .... 94041.005643: fib_table_lookup: table 254 oif 0 iif =
1 proto 6 10.133.162.32/41670 -> 10.10.166.38/445 tos 16 scope 0 flags 0 =
=3D=3D> dev eth0 gw 10.133.162.1/:: err

I was trying to check the input parameters of the related functions using
bpftrace, but unluckily I lost the repro as the VM was rebooted by accident=
.

It would be great to have your insights while I'm waiting for a new repro.

Thanks!
-- Dexuan

[1] https://git.launchpad.net/~canonical-kernel/ubuntu/+source/linux-azure/=
+git/bionic/tree/net/ipv4/fib_trie.c?h=3DUbuntu-azure-5.4-5.4.0-1064.67_18.=
04.1#n1312
