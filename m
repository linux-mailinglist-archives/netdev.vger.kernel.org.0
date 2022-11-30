Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4DA63D9BA
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 16:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiK3Poz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 10:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiK3Pox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 10:44:53 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD1D813B2;
        Wed, 30 Nov 2022 07:44:52 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AU8rddD030044;
        Wed, 30 Nov 2022 07:44:38 -0800
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3m642d99r7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 07:44:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1d7khFcIwsiP0ktVuOyDeyW4yim3VCcS12JPR9EWPrExtj+ELdlzMJB3ohvBNRwGx2FQen/Kvh6a62xYV+gBmfjKeAd9sPCKiToRrE0X2v75GnXNI0XCXQT37lzrFtVh0G4WniR1P0MEilDmiNRByn5jC25NY61BoUmtRlDLSfUUTPwAmpr0gZKyBTVMTV/TrvAd+pW3KPfveQHcxugtaz8EMupt2TGtVsP/mpex8zgUdro4wnMLB+FtODZYsj7UvtpfweE3I8dQO4+Ph0NY/KpjW1+wj/YvtPSrEYKoYvRA5JreK/AVyJQESlAeBBkRsMNev1PqzMECaf7CNW4ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bFiHSXtcRJL7dBJ87Og6+XYpib5q6br39YJsxDBEbUY=;
 b=cWyHVhO8DAQPZT8cW8bVVbZjmskw98VEgt6b2ePVzNZ4kirBhov7sD8MVySqu9KS/spW2/NnA/xgrPn3YA8JrboOrFh8F/ISPHfOfvKHNnL1F38FDlhjx3JUnsQZ0w7oPbKb9W61cfHwrniUwxe0KC0bGCUymmz5lY8ElN6E4/kkP41X048qdJTVAUyQC3jc90P3fBLFZ5q/BX/m+PhaQYYkEW0ZUvgqoRFgfUvqAAsawTYguRwvrkqBKQwVbsmP5NYhVypYTSUmeboXj/sxsDHX2eHmL8Y12kzchoi78+8Kec9wrQYRmtFBhDRFsxCLXfffhmkB7PzAgG7WR3UsCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFiHSXtcRJL7dBJ87Og6+XYpib5q6br39YJsxDBEbUY=;
 b=PuQtp3IqIAxq1NwWFZImm0HnunVXHeJloGNZqNNizmRd/I4YfhyWu7DCqNLgWnH6ZupV6K1wpY9qTrs/8WlNxr6RlXnFkqnRfu3TXMw+3fTGviHwidCTxmyygiFoeiNFFkyw8AnBCuJz6+fHB99QSGEGjbqcm5O3qaaAHD3XwqM=
Received: from BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28)
 by PH0PR18MB4781.namprd18.prod.outlook.com (2603:10b6:510:ca::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Wed, 30 Nov
 2022 15:44:31 +0000
Received: from BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::81c8:f21b:cf9e:df2d]) by BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::81c8:f21b:cf9e:df2d%3]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 15:44:31 +0000
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liron Himi <lironh@marvell.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Sathesh B Edara <sedara@marvell.com>,
        Satananda Burla <sburla@marvell.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: RE: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for control
 messages
Thread-Topic: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for control
 messages
Thread-Index: AQHZA/PZs+9RX6z1+0m5ZGIy8eBWva5XNNSAgABoFsA=
Date:   Wed, 30 Nov 2022 15:44:30 +0000
Message-ID: <BYAPR18MB242397C352B0086140106A46CC159@BYAPR18MB2423.namprd18.prod.outlook.com>
References: <20221129130933.25231-1-vburru@marvell.com>
 <20221129130933.25231-3-vburru@marvell.com> <Y4cirWdJipOxmNaT@unreal>
In-Reply-To: <Y4cirWdJipOxmNaT@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcdmJ1cnJ1XGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctZGY2ZmE3NzQtNzBjNS0xMWVkLTgzNzItZjRhNDc1?=
 =?us-ascii?Q?OWE1OGFjXGFtZS10ZXN0XGRmNmZhNzc2LTcwYzUtMTFlZC04MzcyLWY0YTQ3?=
 =?us-ascii?Q?NTlhNThhY2JvZHkudHh0IiBzej0iMzA5NSIgdD0iMTMzMTQyOTY2Njg4MDk3?=
 =?us-ascii?Q?NjEyIiBoPSIzWXNqV2QxcHRkRVJaRjY2TDNjWFQ0eEgxUnc9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFQNEZBQUJN?=
 =?us-ascii?Q?SmNtaDBnVFpBY0ttcWRoVDh0ZXd3cWFwMkZQeTE3QUpBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFDT0JRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQStSRzhlZ0FBQUFBQUFBQUFBQUFBQUo0QUFBQmhBR1FBWkFC?=
 =?us-ascii?Q?eUFHVUFjd0J6QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdNQWRRQnpBSFFBYndCdEFGOEFjQUJs?=
 =?us-ascii?Q?QUhJQWN3QnZBRzRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFnQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBBWHdCd0FHZ0Fid0J1QUdVQWJnQjFB?=
 =?us-ascii?Q?RzBBWWdCbEFISUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCakFIVUFj?=
 =?us-ascii?Q?d0IwQUc4QWJRQmZBSE1BY3dCdUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1FB?=
 =?us-ascii?Q?YkFCd0FGOEFjd0JyQUhrQWNBQmxBRjhBWXdCb0FHRUFkQUJmQUcwQVpRQnpB?=
 =?us-ascii?Q?SE1BWVFCbkFHVUFYd0IyQURBQU1nQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVpBQnNBSEFBWHdCekFHd0FZ?=
 =?us-ascii?Q?UUJqQUdzQVh3QmpBR2dBWVFCMEFGOEFiUUJsQUhNQWN3QmhBR2NBWlFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJrQUd3QWNBQmZBSFFBWlFCaEFHMEFjd0JmQUc4QWJn?=
 =?us-ascii?Q?QmxBR1FBY2dCcEFIWUFaUUJmQUdZQWFRQnNBR1VBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?VUFiUUJoQUdrQWJBQmZBR0VBWkFCa0FISUFaUUJ6QUhNQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFEd0FBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBYlFCaEFISUFkZ0JsQUd3?=
 =?us-ascii?Q?QWJBQmZBSFFBWlFCeUFHMEFhUUJ1QUhVQWN3QUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR18MB2423:EE_|PH0PR18MB4781:EE_
x-ms-office365-filtering-correlation-id: 9bb74de6-9233-4a76-3809-08dad2e9c58c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NgkJHbaP9TJaAYgjsBtNU9MJU1CyqYXSJp9uI2Ti9hnHijwVUGC13ISPz5my65e6xlGLjUiDHMzQNXx5xGFw0ZOSRRL7WqN6O6EHP+9jpEy7gMkMnlcm1yjQeKolfMcudXddhyzpj569t8Sd/L2ElwvHe9+4/8F2FgKn2J9KoUBCgKfdwwq9BFf+Y6gorugBmBsvdOKRZKQ+ZgpIZe/259BsmHtCRNzQLNqw05sN6Qr7fvjAvdrbVg832HeCEN+gjekQxDAaw8XeMbXxvNu6w60ksLHZOzy5IrU22Ph0Qkltzhmp/ktSTllaBsCvizXwQUQR8sSNZyaahE80vefucszLDndizxABaJCFDu6Y0lWsG9fAN7gGtCkMH6/4AOGAZiOlzIl3cE36xRUQS8s6tYReCdQ9kwGWXPd+GqF5ZH7R1ZsIk64mt3/WMu9z/dDKwB/A5Ft3dpK5z4jpkyvkiPER/OWlSAEpd3TmTCEc1obFnr2+a2X7bYb5bPjoOI7xq8ReY8YW/Iuvycz4T3Q1xfhAnOAkyxmvL2QnTo2BACCdcUc4gDOMKS1TZ+yws4Sz7GloI+dtQQe1IMpkJP+DxofFna/Z/35cG3x0u8UxcYc73mc9ajJqhkm8Mx2XYjDYJ+DW/cKnM/ERAdZ1u8Cyfly+ExyBpbgF48qJCoApPAlTzt8EEWVnQJyCS1X4agX0tty8FBzAfdJOo30GU9U59Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2423.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(451199015)(33656002)(55016003)(38100700002)(122000001)(38070700005)(8676002)(15650500001)(7696005)(83380400001)(86362001)(8936002)(478600001)(64756008)(66556008)(66946007)(76116006)(4326008)(316002)(71200400001)(186003)(54906003)(2906002)(6916009)(41300700001)(9686003)(66476007)(66446008)(52536014)(26005)(5660300002)(53546011)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kbooCD5D9XhEwh9Ghb1ZK4Zk/HoYrzBKnry1ZxO5xXcETWDRZ1micNbgpfuO?=
 =?us-ascii?Q?Fymp1BwYHb3muETy2nKwDVcC/w57F31abnAclr/d+VeyTcv+EIDIGENke83w?=
 =?us-ascii?Q?SmpRE1Pd5n0AagMicY2V0u64uaASWByUom2LHuIfU59SD+QwECT4bjOrbQWR?=
 =?us-ascii?Q?wgouTR56rbySww3eBXOfgASV/l0vNhzLZZfJCGSchyOz18JmZg4N/KKNwM4x?=
 =?us-ascii?Q?fE562m8yncLUrnpYoetuu7P+eJzjD4TfraVBgJCiGorCeeRtGcnh2dyww98H?=
 =?us-ascii?Q?Ex13Rwd24fSGU3IwIsqwumc30TNyDGP16+qxtDGSlbj1IGu5wCtK00NG/zD1?=
 =?us-ascii?Q?B8bYscnCyrfB9XJxuewwCVIuItDRc4ekta4mX5NJ8elruDDaXqhNlkpodk/1?=
 =?us-ascii?Q?4a8Irh3l7sGrJiayh4sSB9XUG+HMGbug4ms5pQvi/fbjSyz0nAWVcsTOstd8?=
 =?us-ascii?Q?3OdZ6Sg0e/6chHawP7DUtu/weJyaRWtpscVIJYHYOhhg/gsyc0p1ZK3BsDk5?=
 =?us-ascii?Q?rgeP6hFhiqdHIKUy680V32VgHLNWdJIogKlNDyyXBtEg9G8ewmSoQRNGk5Ao?=
 =?us-ascii?Q?IeMub7q7b0Ps9qw79LolQ+U78+eoCl9F5RMwQ+kI7nagSnkBaJlMAicj0aVb?=
 =?us-ascii?Q?lqWudI+Bmz6oADamhzQxKUERZohT4GsJ2Jodl+zPMwueJDcKU2A5aO4LN3aP?=
 =?us-ascii?Q?Dcm2zQQotPxta+V1MgpGmaTb/UFMfdWEkkR+F2Nk7YyB48arvpEo9PyTk8H4?=
 =?us-ascii?Q?dgCP/x/zGnXYBf1CbpWIhf6ioZp3xGx+PQzczUDWHOZqLK4vO3Cp30tiYdxp?=
 =?us-ascii?Q?CXQEs/De2H0QeqU/zzQDyavTzZHeODY8ya9OKdOp8/bwuvsQF5uQmpINBkuF?=
 =?us-ascii?Q?EPZrnm9LJew0K2n8RbYeLTci3vJmbbh9XLl4ukefbI35havlsa5Tw12tPtPF?=
 =?us-ascii?Q?WG4V/LRTd8TCo9xOkSqrZSgNqCJzP1nHVDfZ/LO4vWRXuTmJ4g1NIJf3lEjB?=
 =?us-ascii?Q?vIDGQFRIm/pNrcLaHqofVFilc/+4rsXxodOwAZMHf2GtO4ejhWuE3mESFygk?=
 =?us-ascii?Q?/nzxonxqzxrQAtX1UHpB41V7yEZ+3+mrlRnk6C4yx98gJRbiAgXJApBSTrmO?=
 =?us-ascii?Q?8Fb8My1FT0/8pehkJ7InXAdB0kcwNq0ktp4yaxEZp/rCuN8zrUHxHq6mWjTF?=
 =?us-ascii?Q?5kOCZW/PBG0N7b62KiJ+m7XvbCZJYlXh0Mnk3Ot1377hIJtO4lqEHy2W+G6R?=
 =?us-ascii?Q?y389WJYRXt4V0YrT+q6rCwDTOWLCuJsHVznqFKgU98n6qDxfxGQsZ9RA9QDu?=
 =?us-ascii?Q?ewLXDttWlNfQ9EUrfcMcL9IGK4kyhcUDryJoQJibRlh257ximJgRd3N/+P/7?=
 =?us-ascii?Q?kfN5iU0RsjPgy9qQMojoOwwetBPB+pB2fRraSJKXHoVIsjnRAWdyUls9X9Xm?=
 =?us-ascii?Q?jFHIZPT7GOuvxiLSmFeoNGRUvTY+dkkf+gBhK8H9khzk4+lmk9YaD3Qqiwba?=
 =?us-ascii?Q?AQbYsR3jV+v/HRHbF0+fD0SZRbocv21Yx1v9rWYv8ZUx7ZeDS93CR92p2ZWB?=
 =?us-ascii?Q?CbK538q7/VBKomGTCTU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2423.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb74de6-9233-4a76-3809-08dad2e9c58c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 15:44:30.9547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qTHI9H9dcCw4YlCUNcB/xCW1fECeErc+/bAwXxm5xksGo6DKm2j+DUeinXf3XrgDQ7zKQm8ObVPpNtU6/hOtzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4781
X-Proofpoint-ORIG-GUID: KCNp_7rpFVMTpKVn-f23M6m7ucqu-MSH
X-Proofpoint-GUID: KCNp_7rpFVMTpKVn-f23M6m7ucqu-MSH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_04,2022-11-30_02,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Wednesday, November 30, 2022 1:30 AM
> To: Veerasenareddy Burru <vburru@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Liron Himi
> <lironh@marvell.com>; Abhijit Ayarekar <aayarekar@marvell.com>; Sathesh
> B Edara <sedara@marvell.com>; Satananda Burla <sburla@marvell.com>;
> linux-doc@vger.kernel.org; David S. Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>
> Subject: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for control
> messages
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Tue, Nov 29, 2022 at 05:09:25AM -0800, Veerasenareddy Burru wrote:
> > Poll for control messages until interrupts are enabled.
> > All the interrupts are enabled in ndo_open().
>=20
> So what are you saying if I have your device and didn't enable network
> device, you will poll forever?
Yes, Leon. It will poll periodically until network interface is enabled.
>=20
> > Add ability to listen for notifications from firmware before ndo_open()=
.
> > Once interrupts are enabled, this polling is disabled and all the
> > messages are processed by bottom half of interrupt handler.
> >
> > Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> > Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> > ---
> > v1 -> v2:
> >  * removed device status oct->status, as it is not required with the
> >    modified implementation in 0001-xxxx.patch
> >
> >  .../marvell/octeon_ep/octep_cn9k_pf.c         | 49 +++++++++----------
> >  .../ethernet/marvell/octeon_ep/octep_main.c   | 35 +++++++++++++
> >  .../ethernet/marvell/octeon_ep/octep_main.h   | 11 ++++-
> >  .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |  4 ++
> >  4 files changed, 71 insertions(+), 28 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > index 6ad88d0fe43f..ace2dfd1e918 100644
> > --- a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> > @@ -352,27 +352,36 @@ static void
> octep_setup_mbox_regs_cn93_pf(struct octep_device *oct, int q_no)
> >  	mbox->mbox_read_reg =3D oct->mmio[0].hw_addr +
> > CN93_SDP_R_MBOX_VF_PF_DATA(q_no);  }
> >
> > -/* Mailbox Interrupt handler */
> > -static void cn93_handle_pf_mbox_intr(struct octep_device *oct)
> > +/* Process non-ioq interrupts required to keep pf interface running.
> > + * OEI_RINT is needed for control mailbox  */ static int
> > +octep_poll_non_ioq_interrupts_cn93_pf(struct octep_device *oct)
> >  {
> > -	u64 mbox_int_val =3D 0ULL, val =3D 0ULL, qno =3D 0ULL;
> > +	u64 reg0;
> > +	int handled =3D 0;
>=20
> Reversed Christmas tree.
Thanks for the feedback. Will revise the patch.
>=20
> Thanks
