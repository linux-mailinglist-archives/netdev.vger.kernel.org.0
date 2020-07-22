Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE4B229BA9
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732726AbgGVPlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:41:44 -0400
Received: from rcdn-iport-9.cisco.com ([173.37.86.80]:28858 "EHLO
        rcdn-iport-9.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbgGVPlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:41:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=694; q=dns/txt; s=iport;
  t=1595432502; x=1596642102;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ol4iiUhkrvBy3pEOwJ1GuwrkaIgCuPaJNyAhLe4A4C0=;
  b=DsnSZVT9gnBa3ChUga5sDoVtNqQEJd9+TOhmR7K7dQLcneZ2cS+PdQC+
   6JzvfRk2ExITHhu/2Ldmtz2MzNjv5vhieDBCiuC4YcenG9myy+AuG1jxC
   +nMJc3TT6vfg4SU5VjWAzoVY17NVFGkHZi/gUWVKIYhDNY6t84+gvXcU2
   w=;
IronPort-PHdr: =?us-ascii?q?9a23=3AlvokmhYT7HjevQg+MbPCqeT/LSx94ef9IxIV55?=
 =?us-ascii?q?w7irlHbqWk+dH4MVfC4el21QaXD4bW8fRJj6zRqa+zEWAD4JPUtncEfdQMUh?=
 =?us-ascii?q?IekswZkkQmB9LNEkz0KvPmLklYVMRPXVNo5Te3ZE5SHsutZFDIpHC2qzkIFU?=
 =?us-ascii?q?a3OQ98PO+gHInUgoy+3Pyz/JuGZQJOiXK9bLp+IQ/wox/Ws5wdgJBpLeA6zR?=
 =?us-ascii?q?6arw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AfCgA0XRhf/5BdJa1gHgEBCxIMQIE?=
 =?us-ascii?q?/C4FSUQeBRy8sCoQpg0YDjSclmF6CUwNVCwEBAQwBAS0CBAEBhEwCF4F3AiQ?=
 =?us-ascii?q?3Bg4CAwEBCwEBBQEBAQIBBgRthVwMhXIBAQMBEhERDAEBNwEPAgEIDgwCJgI?=
 =?us-ascii?q?CAjAVEAIEDgUigwSCTAMOHwEBonUCgTmIYXaBMoMBAQEFhSIYgg4JFHoqgmq?=
 =?us-ascii?q?DVYYzghqBEScMEIJNPoQ9gxYzgi2BRwGQVjyieAYEgl2ZZgMegmkSiUCTFi2?=
 =?us-ascii?q?wYAIEAgQFAg4BAQWBaSSBV3B6AXOBS1AXAg2OHoNxilZ0NwIGAQcBAQMJfI4?=
 =?us-ascii?q?WAYEQAQE?=
X-IronPort-AV: E=Sophos;i="5.75,383,1589241600"; 
   d="scan'208";a="710938515"
Received: from rcdn-core-8.cisco.com ([173.37.93.144])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 22 Jul 2020 15:41:41 +0000
Received: from XCH-ALN-003.cisco.com (xch-aln-003.cisco.com [173.36.7.13])
        by rcdn-core-8.cisco.com (8.15.2/8.15.2) with ESMTPS id 06MFffl1021973
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 22 Jul 2020 15:41:41 GMT
Received: from xhs-aln-003.cisco.com (173.37.135.120) by XCH-ALN-003.cisco.com
 (173.36.7.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 10:41:40 -0500
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by xhs-aln-003.cisco.com
 (173.37.135.120) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 10:41:40 -0500
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-002.cisco.com (64.101.210.229) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 22 Jul 2020 11:41:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwPmC/Vun1SJ8AYag9YgNpNprQGIAJhRI2UrPLfn0E1Zm/etZj2jO3ajpXaimHVeVvYg2YXviCzNlScThKrzMbhT1PJUuaZFm/0/hS2qXoQHrJqazRlWB/KLBjIPRJmLMmgmLRQt83DPV8tXguDBMhSlUYNR7uZqDNszIz6sMprrOdGpDI2k5iEcIB2BnXtR9OPn6j4ce+eNd6jLj/bhXqebyB1OHW6RJl96x9ACRXE8bUbrdXsyZQfk1JFyjx43YkoeSLZV9pIBfL+WePnU7OUg0AtWptmE1MWtmyrx3NYT8GDcsLk12/hNLdKzffouD5Yi8umC2fwksPInp7XuQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ol4iiUhkrvBy3pEOwJ1GuwrkaIgCuPaJNyAhLe4A4C0=;
 b=a6R4RrV0jvQnlLvvj8vrPzKzBQ8nhJcm7sqHRqkrgmNtgkITq5AMtKvdTXgYZGIPoHGLScdeOpS+shkijNtf3JVJydO06A7qPaPdaV2SlcoPmc/fPR0Tqsdti9T9TvwBgqQvsn+OaSBDdCRho533s3iRIeN/Uwe6ZTeE5ZPSpMcNchvgUyETAeqAlpSMeAjI+k8rNVgn9oLCyxLpQCPRVO4wuLZj1bCNrZXskOzrsZNBqQ/CkyXAOJBqwJoN3i0WGz8lsc8AQ3YxhDEMmbCNzTIvOF/THFdUjVDlsSXzrZVYFR6bdQmV91hRHYcBvNc3A0C8klcxx1G3GqG4WztXeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ol4iiUhkrvBy3pEOwJ1GuwrkaIgCuPaJNyAhLe4A4C0=;
 b=NIe38779Zt6tYsyL9v2mTUjoMc7yBnUS7nBdPrh/jZv2FH12Dgbs96HiLOblY9fF25IpCUJD9BthkxC5A3aZbYB3ly0LagHdy+m/nHZPkV5jqodgw/hgb56KVlanmKAi7Mr7zRc4mNtRD2dBNS3LDkTgRYR+IeMBKN1Tzk0+VNM=
Received: from CY4PR1101MB2101.namprd11.prod.outlook.com
 (2603:10b6:910:24::18) by CY4PR11MB1765.namprd11.prod.outlook.com
 (2603:10b6:903:126::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Wed, 22 Jul
 2020 15:41:39 +0000
Received: from CY4PR1101MB2101.namprd11.prod.outlook.com
 ([fe80::6c4e:645e:fcf9:f766]) by CY4PR1101MB2101.namprd11.prod.outlook.com
 ([fe80::6c4e:645e:fcf9:f766%11]) with mapi id 15.20.3195.025; Wed, 22 Jul
 2020 15:41:39 +0000
From:   "Sriram Krishnan (srirakr2)" <srirakr2@cisco.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "Malcolm Bumgardner (mbumgard)" <mbumgard@cisco.com>,
        "Umesha G M (ugm)" <ugm@cisco.com>,
        "Niranjan M M (nimm)" <nimm@cisco.com>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] hv_netvsc: add support for vlans in AF_PACKET mode
Thread-Topic: [PATCH v5] hv_netvsc: add support for vlans in AF_PACKET mode
Thread-Index: AQHWYDt0UcpbuUSjfUuYsKmDjtlFy6kUGOeA
Date:   Wed, 22 Jul 2020 15:41:39 +0000
Message-ID: <5BFB5D28-3A27-4945-960A-9962064FC2C8@cisco.com>
References: <20200722070809.70876-1-srirakr2@cisco.com>
 <20200722081904.4a924917@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200722081904.4a924917@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.39.20071300
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [106.51.23.252]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba64a8c3-548b-4b2d-f4ae-08d82e55b9b1
x-ms-traffictypediagnostic: CY4PR11MB1765:
x-ld-processed: 5ae1af62-9505-4097-a69a-c1553ef7840e,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR11MB1765E794040A55A39728E86A90790@CY4PR11MB1765.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i2RSrxpBRApfmYV8w321lV2K7ENjRPcn5x+wPUhjrZxBSHD2ukWf0NTfDFzXUw9dm792You75Th4Gx2tYtGsGrjbtp9MjrAxnW4Ry6lNXL0qWdcv3LDtDkajz6e1N1MFTEqw9UxyMpbMThuj/wGszw7BbU+VfAIoMNc3DLlRG4TEoglKTziBDez2AQRHOkdXJz/+/IwkVJqYY3D7LrFY0c1lcLfP7+HoOvu633c8Zifu08XeeCDB+x4y/NhNeZ2tXXkldsEyvQY4kF+UqijFA/AeZ1Pwzi70UmoiOcGsCUh0CLckEEploE0Y7k3qdZbU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2101.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(4326008)(2906002)(478600001)(6506007)(8676002)(6512007)(5660300002)(8936002)(83380400001)(33656002)(2616005)(4744005)(55236004)(36756003)(26005)(316002)(64756008)(66946007)(6486002)(66476007)(76116006)(91956017)(71200400001)(86362001)(186003)(6916009)(54906003)(66446008)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: vO9Ik7uUGE33fh925hKkIZxznbPG8Zgj7Gtk1i41knKiKkEFQYQs77aZEWWGlTmyuDSHoH1ucBS8CWUOwHGt7+583CLterMHZvaU/VZ92JJhsU5M6lNxbMbgx8OZ9F4/UmzEme+PqLPFySkQXopOz8TxGt1OmZSVjgHWQPmsD9naZ08Lkis+147D+AUKOixw+CMRnYTgvMdg3sDSQeansmKbfvZzkJQZQ4RWLQhgE+nFgp9zc6Xm4eWSixSWaIe+m23NHN9Bt9eKmHBsodDby6Md9EiSC9NjLzc40bv0kP/ocKk2ckL0iCRm2/oNX155ElagTPooEdDZwnclhIMjmeNvZ8chMPYTvxtI0hWxv0f4iFWoAcOZ49QMcG+Wpmbe3LbNW0cS0oeWY+UuqxNP2FAAey3A+Y/lJNNlyEtNYIL3NtIbGCn1qDOaqZj8tkKFi68PS7qndVMYfvPBeVBTMotfW9cHuTTxcHp1ieQuOXw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F6C9994F87DAA74C82BEC64C69FE6476@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2101.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba64a8c3-548b-4b2d-f4ae-08d82e55b9b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 15:41:39.4111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qvqQobeBtL59FNx7UXvpkMElbBcZ0f18kFNmSGQENFs+KqiERK8hD2odVBHH1ZUwd+9/cJ77K/z0/QncvI7znA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1765
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.13, xch-aln-003.cisco.com
X-Outbound-Node: rcdn-core-8.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDIyLzA3LzIwLCA4OjQ5IFBNLCAiSmFrdWIgS2ljaW5za2kiIDxrdWJhQGtlcm5l
bC5vcmc+IHdyb3RlOg0KDQogICAgPiBQbGVhc2UgcnVuIGNoZWNrcGF0Y2ggb24geW91ciBzdWJt
aXNzaW9uczoNCg0KICAgID4gV0FSTklORzogTWlzc2luZyBhIGJsYW5rIGxpbmUgYWZ0ZXIgZGVj
bGFyYXRpb25zDQogICAgPiAjNzY6IEZJTEU6IGRyaXZlcnMvbmV0L2h5cGVydi9uZXR2c2NfZHJ2
LmM6NjE0Og0KICAgID4gKyAgICAgdTE2IHZsYW5fdGNpID0gMDsNCiAgICA+ICsgICAgIHNrYl9y
ZXNldF9tYWNfaGVhZGVyKHNrYik7DQogDQogICAgPiBFUlJPUjogY29kZSBpbmRlbnQgc2hvdWxk
IHVzZSB0YWJzIHdoZXJlIHBvc3NpYmxlDQogICAgPiAjODE6IEZJTEU6IGRyaXZlcnMvbmV0L2h5
cGVydi9uZXR2c2NfZHJ2LmM6NjE5Og0KICAgID4gKyBeSV5JXkl9JA0KDQogICAgU29ycnkgYW5k
IHRoYW5rcyBmb3IgdGhhdCwgcmVzdWJtaXR0ZWQgdjYgb2YgdGhlIHBhdGNoDQoNCg==
