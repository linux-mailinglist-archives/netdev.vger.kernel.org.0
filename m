Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0820E1A4A4D
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 21:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgDJTUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 15:20:22 -0400
Received: from mail-eopbgr680132.outbound.protection.outlook.com ([40.107.68.132]:21059
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726203AbgDJTUW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 15:20:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALh1zzl3fq83aIhtB9KsbNgEnrsb3nJ2W4GRQ3MHByQASOhixXZpVTCRC3lmObNCL+ZokbQaa9HmDJxKrjMOFcoCK9pldJ4VEe2qNhguE2Bdskudr/iDtE0O+i7TJgUemoxJo8QvLz9ArgiCW0LD8/OhrAh4lDwDPUl+IMCbzZIvaxGWdMFdzfbEIZOC+GNTl1t9W26bnr3LYXXcvcVz2VmvnqbMRW3QMHlLntRMF6fISor4RL5FTbr+qMzJ/QSWGaaqjd2skqbXc3UzjMj26lC+Y7aiCsn7iJ+EqCRONpnNGzFx2UmZSIQgf6c2gJGBdXnUneJpVt5RCFKDPYvsCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TDNk3yyR7YSxaM8yUD73rkTQlaEOj3/TA3eFBGmJel8=;
 b=hb8d6nemgoiV0n4viXeQMrwxSwqPvnRwZ+sau+iXCLC9x6SuZ5vYtjSCWYhExRhpUJaBOaLyfkTq6igG2dAiLp0IPP11zeDKnmd/+UfvyKAMqTzPsv3vTww6aKSQrFyIvppIDeGPqlw4xZbwzfImYFWMcUinlaHlIyrNQJYNCRXEvYOw0TVJsTejJU9cu3eGhabxt6xbTYf679SewLMGYxMwAM+3kdilMPDcr5mf04ACA5aRuwi0bTUMTp1SCt8q6JtA+uJkMMvu4zivFHkzPX5mn/Ygb64fJJC4WEjM7gbwVsPzCrVa5hQKRBbYnu4dwOT37Xc/2dKU5ERpmA2EjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TDNk3yyR7YSxaM8yUD73rkTQlaEOj3/TA3eFBGmJel8=;
 b=OY6+RkKX72OxowetOgAMxv3ZokVZtTLz2p4s/jnVfG+1Ss65jCWe7Su8zMXZ+Ymemi46M3CI2k04poQx6TXE8EqAzuqGvVO5HpF+84wsieEDSoqn8Ohnld816SFv4OCEjXfexKnmpTeEBCciWoZfi1VElt1So2pDME8KQtP5OKA=
Received: from DM5PR2101MB1047.namprd21.prod.outlook.com (2603:10b6:4:9e::16)
 by DM5PR2101MB0920.namprd21.prod.outlook.com (2603:10b6:4:a7::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.4; Fri, 10 Apr
 2020 19:20:16 +0000
Received: from DM5PR2101MB1047.namprd21.prod.outlook.com
 ([fe80::f54c:68f0:35cd:d3a2]) by DM5PR2101MB1047.namprd21.prod.outlook.com
 ([fe80::f54c:68f0:35cd:d3a2%9]) with mapi id 15.20.2921.009; Fri, 10 Apr 2020
 19:20:16 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        vkuznets <vkuznets@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 04/11] hv_netvsc: Disable NAPI before closing the VMBus
 channel
Thread-Topic: [PATCH 04/11] hv_netvsc: Disable NAPI before closing the VMBus
 channel
Thread-Index: AQHWC6iqL0HJm9zpvUqAkD991LoOl6hywpug
Date:   Fri, 10 Apr 2020 19:20:16 +0000
Message-ID: <DM5PR2101MB1047792102EAE9C52D4ED5E9D7DE0@DM5PR2101MB1047.namprd21.prod.outlook.com>
References: <20200406001514.19876-1-parri.andrea@gmail.com>
 <20200406001514.19876-5-parri.andrea@gmail.com>
In-Reply-To: <20200406001514.19876-5-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-04-10T19:20:14.1433724Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=28bfb3eb-fa58-4ccc-bc6d-1806b048cde5;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3291aecf-8fd7-41db-e530-08d7dd843384
x-ms-traffictypediagnostic: DM5PR2101MB0920:|DM5PR2101MB0920:|DM5PR2101MB0920:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM5PR2101MB0920472717C0034345D7E4ADD7DE0@DM5PR2101MB0920.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0369E8196C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR2101MB1047.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(76116006)(81156014)(66556008)(55016002)(66476007)(82960400001)(33656002)(186003)(86362001)(4326008)(10290500003)(7696005)(9686003)(5660300002)(478600001)(4744005)(8676002)(6506007)(26005)(8936002)(82950400001)(316002)(71200400001)(110136005)(54906003)(64756008)(66946007)(66446008)(2906002)(52536014)(8990500004);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1UjPg1kSXi7mbXButWltsv/g9ktCMimOaBJdlbT0vS+Z50EGUcHlEEIs2CAWUhOJwNCAtMQPaG/Cy920gZluO2DjNzxSM8ZMgzv7F6kSyWkZuiqPk8tBy8xBqz6/R6mGzxA+QhhgSxxl4KlxJxWLKkNugtoY4SQjIoSdiMjFtcb7Zk2SnLw0hFIjiUMiCBpUbsDRzxdtRFQ/RqfTvrD2Ltudiu6agJsE4Y2XdsBJ3ERC09RSCg+NGnJunuW2alUrq2fLkVKYm3OkXeGqL3TCfQgM/iV0e5bXxybv8Nog4mus5Vff+0e7d05qS0mHEeSx/nLBvQJEW/OA1UFp8M2aG/d9bPNrjjW5o4dIF4V2cGOIRAGADQDdfhi+h+UhySFNwc6KcBQqL7ozCQq9+3xweR7q+2tkqscCANINhU2GrD0KzOCmIYy+QoychUV8R94i
x-ms-exchange-antispam-messagedata: mIvebLqxcpN+Cz0/dCoEBHNOMhhRwuHKKimeBEtRG/Fa3fGV91rQ9F6kA66jCWi0qtm5JQwC5lMlBgPj6RumVu3v6xs8KCFVRNwZgtLCPDpTiShB45pxjKWmQIvKgiXZITchZ3m6mdMm3sOPgeTfTQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3291aecf-8fd7-41db-e530-08d7dd843384
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2020 19:20:16.5054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hQCSVXbYN3y5Y+0OjLdoJBumRMXBelTx/hEflO/KYPrcikuO9TOZl4hYJGtwxHICQDPsjjl1QAo+16NQbPaLEcrGHOOdPFndXi8Lob7AIIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0920
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Sunday, April=
 5, 2020 5:15 PM
>=20
> vmbus_chan_sched() might call the netvsc driver callback function that
> ends up scheduling NAPI work.  This "work" can access the channel ring
> buffer, so we must ensure that any such work is completed and that the
> ring buffer is no longer being accessed before freeing the ring buffer
> data structure in the channel closure path.  To this end, disable NAPI
> before calling vmbus_close() in netvsc_device_remove().
>=20
> Suggested-by: Michael Kelley <mikelley@microsoft.com>
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Acked-by: Stephen Hemminger <stephen@networkplumber.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: <netdev@vger.kernel.org>
> ---
>  drivers/hv/channel.c        | 6 ++++++
>  drivers/net/hyperv/netvsc.c | 7 +++++--
>  2 files changed, 11 insertions(+), 2 deletions(-)
>=20

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
