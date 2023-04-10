Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 143826DC4DD
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 11:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjDJJI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 05:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbjDJJIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 05:08:54 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6C93ABD;
        Mon, 10 Apr 2023 02:08:51 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 339LpE82026521;
        Mon, 10 Apr 2023 01:43:56 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pu5ms79qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Apr 2023 01:43:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uqweb6eSf5wIMUjsCPkg9y83dtPcJCiuRPnT0l4a2oKEavOCaSswZn18SLLwvrgqCYbiqPK+Qzex8lnmaoA0SLMcFqk9wpU6T6kjPcoFhAosKHsbATk6MDFd5dV1FJM4R0KWTfl8eYYu1F2KduXmyRomUWYJxRG6qohp3Bk7XqI8y3Xc9lZRMVohuv/y2wE5E+ucfNIVu4jyGs9V1xHFc4LYw5BEq0geag6t+UQKbSYBqzFUzSzk3As9hgxb8SOoDHUl5s21u95XNNjczdmID/iI8e1SsiVkswoR+WhtSAvmLVfuGplWyQ6AABGayVUWhhmRVdV/m5cL6WLxk2G8bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qPIcx0zfhCEQzF2g8v23jPNNawORv1AsvCHLQhVKH3s=;
 b=VCoeOc403uiLggdCUYVAilu1kM6bQpAmotEpv+EmotD7a5195hM1YFyVnFOsxpOHxI/egilMVVkU4xfl8XX3kY/flPJl3SjVZoebEsaBs9qV9xrXwx1NH4yPhZmRTPvZBCPhA7HtxuadwCaLrppohlVzCnOv4SRAG2Yr+OS2G+P/+jbcqWea+DJfrJwAkss6tn3IXqjNE5iewsKJpyrrY+7+KMKOjCk9uZcKdq3anptH4ahH27z/sVeOiIii+vZ8r4+vR1ft1F3L5SnGcsDee9fRfa/T1BW38tgBAbhuV8I4J2aFYLk6SGYcKToMfGvcjkx6hSADxcXKt15HREmsGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPIcx0zfhCEQzF2g8v23jPNNawORv1AsvCHLQhVKH3s=;
 b=vHXYiqMRCLmceFAWkNaG+YCUiW6veajk1kfD/P4LyWm5ZTQUt9dYRstg9i9lt+vDDP130bxTU7zRI+aYIN7OCy+pnwaCz7mr/dnyZoyNVzogsqf/4tFPF6oHZTeclmMAFYeU4XaNS2WVh1hVdC3ezvDdAjFB8m0KJP1dDJfSQBI=
Received: from BY3PR18MB4707.namprd18.prod.outlook.com (2603:10b6:a03:3ca::23)
 by PH7PR18MB5129.namprd18.prod.outlook.com (2603:10b6:510:158::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 10 Apr
 2023 08:43:51 +0000
Received: from BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353]) by BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353%4]) with mapi id 15.20.6277.031; Mon, 10 Apr 2023
 08:43:51 +0000
From:   Sai Krishna Gajula <saikrishnag@marvell.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: Re: [net PATCH v2 5/7] octeontx2-af: Fix issues with NPC field hash
 extract
Thread-Topic: [net PATCH v2 5/7] octeontx2-af: Fix issues with NPC field hash
 extract
Thread-Index: AQHZa4iTzNWI70/imEGdQTM0k6wZwQ==
Date:   Mon, 10 Apr 2023 08:43:51 +0000
Message-ID: <BY3PR18MB470718017D6B5513C87883E3A0959@BY3PR18MB4707.namprd18.prod.outlook.com>
References: <20230407122344.4059-1-saikrishnag@marvell.com>
 <20230407122344.4059-6-saikrishnag@marvell.com>
 <ZDGGbyXDjrnoJRcd@corigine.com>
In-Reply-To: <ZDGGbyXDjrnoJRcd@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2Fpa3Jpc2hu?=
 =?us-ascii?Q?YWdcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZi?=
 =?us-ascii?Q?ODRiYTI5ZTM1Ylxtc2dzXG1zZy1jZjhjOGY4Yi1kNzdiLTExZWQtYWQxYy0x?=
 =?us-ascii?Q?Y2MxMGM0MGQ5ZTRcYW1lLXRlc3RcY2Y4YzhmOGQtZDc3Yi0xMWVkLWFkMWMt?=
 =?us-ascii?Q?MWNjMTBjNDBkOWU0Ym9keS50eHQiIHN6PSIxOTM2IiB0PSIxMzMyNTU4OTgy?=
 =?us-ascii?Q?OTE1NTQxODgiIGg9InBGUEl1MU1xVzNWK0dXaDh0SVNydGtaZXFOUT0iIGlk?=
 =?us-ascii?Q?PSIiIGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUhZ?=
 =?us-ascii?Q?SUFBQ014K1NSaUd2WkFUb3VsSVU3U0RGWk9pNlVoVHRJTVZrTkFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFIQUFBQUFHQ0FBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFFQUFRQUJBQUFBMUZIM2FBQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFH?=
 =?us-ascii?Q?UUFaQUJ5QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFCekFIUUFid0J0QUY4?=
 =?us-ascii?Q?QWNBQmxBSElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFB?=
 =?us-ascii?Q?Q0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFYd0J3QUdnQWJ3QnVBR1VB?=
 =?us-ascii?Q?YmdCMUFHMEFZZ0JsQUhJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJq?=
 =?us-ascii?Q?QUhVQWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QVpBQmhBSE1BYUFCZkFIWUFN?=
 =?us-ascii?Q?QUF5QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-rorf: true
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdB?=
 =?us-ascii?Q?QUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY3dCekFHNEFYd0JyQUdVQWVRQjNBRzhB?=
 =?us-ascii?Q?Y2dCa0FITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWXdCMUFITUFkQUJ2?=
 =?us-ascii?Q?QUcwQVh3QnpBSE1BYmdCZkFHNEFid0JrQUdVQWJBQnBBRzBBYVFCMEFHVUFj?=
 =?us-ascii?Q?Z0JmQUhZQU1BQXlBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFB?=
 =?us-ascii?Q?QUFBQUFBSUFBQUFBQUo0QUFBQmpBSFVBY3dCMEFHOEFiUUJmQUhNQWN3QnVB?=
 =?us-ascii?Q?RjhBY3dCd0FHRUFZd0JsQUY4QWRnQXdBRElBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFu?=
 =?us-ascii?Q?Z0FBQUdRQWJBQndBRjhBY3dCckFIa0FjQUJsQUY4QVl3Qm9BR0VBZEFCZkFH?=
 =?us-ascii?Q?MEFaUUJ6QUhNQVlRQm5BR1VBWHdCMkFEQUFNZ0FBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFaQUJzQUhBQVh3?=
 =?us-ascii?Q?QnpBR3dBWVFCakFHc0FYd0JqQUdnQVlRQjBBRjhBYlFCbEFITUFjd0JoQUdj?=
 =?us-ascii?Q?QVpRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCa0FHd0Fj?=
 =?us-ascii?Q?QUJmQUhRQVpRQmhBRzBBY3dCZkFHOEFiZ0JsQUdRQWNnQnBBSFlBWlFCZkFH?=
 =?us-ascii?Q?WUFhUUJzQUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1VBYlFCaEFHa0FiQUJmQUdFQVpB?=
 =?us-ascii?Q?QmtBSElBWlFCekFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBRVFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhBQWNnQnZBR29BWlFC?=
 =?us-ascii?Q?akFIUUFYd0JqQUc4QVpBQmxBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ0QUdF?=
 =?us-ascii?Q?QWNnQjJBR1VBYkFCc0FGOEFkQUJsQUhJQWJRQnBBRzRBZFFCekFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBRUFBQUFBQUFBQUFnQUFBQUFBIi8+PC9tZXRhPg=3D=3D?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4707:EE_|PH7PR18MB5129:EE_
x-ms-office365-filtering-correlation-id: 9959f866-1ca6-40a2-4463-08db399fb5ca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AhufIKDRYmRnDdAJ1ySg2beZrFHO8G6xbqAqSQzlqVFDI8d1uFRfo/N3o2XHcXqYzybp7WBaTpWMp3W6MZquHNEYvQUHgxSDsnNngzoBvGvrzNS/F/Uwxne1IHay31KbqXeSFFGNpjPZCaBsLpi0wapfsRGRBdWK1tTKne8NsohPQatSjTm0JtVRk08qe5jg8T6XdByQHmz1TD4a/9NNzmcElrscDgmtN79nE76v8qyxXvDsNP5teAomb9CNvq3GacpxNXQ999oY0HpXIiaQilOqhGFQSLQq1RD+VZsJ+MW1KlCJQ+wdYX0sZtX3cQFq+01RU8s2yWUVTDF7eHcP/+aDNqv4InPhdUQcoVyVxcwJxFW1fKKtDc/BH5N6vpQEKVrIKOWEBaMW79NIgO6+OW6eBIvzvYLz3zFMIFIANVigsE6ZJKKVkBaB9AESgaoSHs8+3de1Lar2p8JvouuM96vAbIviAF0WnhRMG5lsym2rXaUu7fJtj6qjq6gUvwNByWZKqOKngBH0n6iiV8JsP/fYUGfeXbGqPx48xIN5v/6W70zsV/BBa1Vzd5vgxO/OiRRtSzVzg1s5FgQca2rRDDyXo4z1hXq0Kw+elJId2ySP8nCZtDa5efZrR/AeI2eG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4707.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(366004)(39860400002)(376002)(136003)(451199021)(4326008)(66946007)(8676002)(66476007)(76116006)(38070700005)(41300700001)(66556008)(64756008)(6916009)(52536014)(66446008)(5660300002)(122000001)(54906003)(316002)(38100700002)(8936002)(478600001)(86362001)(2906002)(71200400001)(7696005)(186003)(55016003)(83380400001)(33656002)(26005)(53546011)(6506007)(9686003)(107886003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VWgLii2G9tdmwCdMWJtJcODL4LumiBUvXugHoPHbRyfM57geeDaGlgXqOvL6?=
 =?us-ascii?Q?VYbmxKFyeHfh6WVXF8LMhBMG3XhXxELQ9XcLtb+Z2ezONcWkNG0YqhGe33yU?=
 =?us-ascii?Q?/H8JLvLn2fFqndgTM4LZxkedscvu4Je74pLSy4P+6jP0EITgIdahcc58RZ0l?=
 =?us-ascii?Q?KCIUDs7W4LqGPqg8Bi3HyuuFC3m4GAd6gUQZMyGxBcg6vRET54qdsh3ttEXu?=
 =?us-ascii?Q?p2j7BH34cdBoknIsPNvoTqibRPlFrtC+czMQXc42dS0LoQPEb3+VuB6ygy5J?=
 =?us-ascii?Q?XZVjH3RJkXBAD+OeeUaM72uz5IR41BdX1eLAsf3PS79pXpPaK6Yh4sLjoPzU?=
 =?us-ascii?Q?REAt5RCXSk1N5ke1zahk/pMjgV261sYeegaaO/pu6Gj+/9iKfjkfLySNMZUk?=
 =?us-ascii?Q?Dxb3q9ctuG1XO5CQBrQlheHFMtwXmeRoSGoXHTvyRys5MYA/RGvjQ5lbnwKi?=
 =?us-ascii?Q?va5cNRmlt/CXZHqx2QqgmShqYtlFp2l/SHbmDxobli649XCUheu/tcZhRumq?=
 =?us-ascii?Q?1iM/Lnxr2ieS7lBQSgFyqHxuH5zArVMXNIFFiVL4VgMQ1A14UMpMGYkoBxZS?=
 =?us-ascii?Q?dAwGL22f/oY1gcHx+ZYPd+5uHqKWHFi563NbBYCov+v9Ir2TgTQD+n6956S4?=
 =?us-ascii?Q?ozyhTgzpAdpf11hE6nQGxEJuMofrJTBcdq8Abzo0Q2PwGmeYnIMLZbW/wkKO?=
 =?us-ascii?Q?QhwwmabnQM1xx40+nXE5apzqSO8KwWXMurmknRH/UaV/DneSRal5ySNEdLmN?=
 =?us-ascii?Q?7V5kRvQ9mmuoRkW+yAjvcsd0p7acDZLu21sOCBIFWhvWgt7AX+8DQGwH1Tje?=
 =?us-ascii?Q?KwiSSCb+GxwTUTVFJyLgFgb6UMMMx87VQ592pUGnEG29yIqF26KqIAWCXWRZ?=
 =?us-ascii?Q?xPIy/oU3eZrfuic7Z7hiKhSxMT7tqJM3QCuCqBU+ikVRSJP5h1MdrKwRzYFW?=
 =?us-ascii?Q?axjO3ouWv5g/cVAYShTqNTNMqnCNmPKDOtTSy7xkGgtrV4fEyu5fmR8hbv4K?=
 =?us-ascii?Q?qCQ6kcM96pacY7jYknkABpPtqzrkFOESAiuQaG4+36EclJnMlLDzpGVNNwvl?=
 =?us-ascii?Q?4ycTP2TdluH73rd0kZ2NmAmzRgMW3AaT1Wzm0CUjC3gyAHWphPAbrBdRUKsL?=
 =?us-ascii?Q?VRKgRY0GiWqTU/1q3bKYU/TKV2u+cO26UAsQuBMvDKMPTDsvJj/gVKtWeZ/U?=
 =?us-ascii?Q?mJ23cyHbm84MvTEL6KPhciXDejnHvnzhjj1n7AfMUYfGTSOfu3djsAyJloaz?=
 =?us-ascii?Q?soBS894FUDJutEXedJ54Y/hwX8rMwqMnMe0YaggNkmum0k+qC1aHiVyUcPXa?=
 =?us-ascii?Q?AWjOVO9DTOkL+OtQD28v+/R266Jo1c/gneOlalp4jasvskdZLiSYCfUrZ77a?=
 =?us-ascii?Q?zsDkBvMduPYp+/9mGpN8KYbrWNIY0CTHphsomW0oEfytEMGqJvRDfWAlPYcn?=
 =?us-ascii?Q?7+bBMQUPWaNCrCg05xadP22cmqMpUdKKXvrSmrBXRTWOWgkhjY6g3FRA9E1K?=
 =?us-ascii?Q?XcYgoje8C++CwM5y6BB3++Ga5Cokk7YbINIOjx3dhaYNPAexX/SGYV2owRv+?=
 =?us-ascii?Q?fwREDiWBp3O2TDcaWmHDJotGgMapG9wBC02wX5kO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4707.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9959f866-1ca6-40a2-4463-08db399fb5ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2023 08:43:51.5310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: npI/oo1rWxHtgPn4Ly0seyLAhdTHUrkTijQNHQWyTyvAK7OHbE+3hLHM29STWwK5OA0NtP1QZU41R79uefR9lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR18MB5129
X-Proofpoint-ORIG-GUID: s-9AOf9yr7l0pJgcY-ypokCoW83hNunz
X-Proofpoint-GUID: s-9AOf9yr7l0pJgcY-ypokCoW83hNunz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_05,2023-04-06_03,2023-02-09_01
X-Spam-Status: No, score=-0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please see inline,

> -----Original Message-----
> From: Simon Horman <simon.horman@corigine.com>
> Sent: Saturday, April 8, 2023 8:51 PM
> To: Sai Krishna Gajula <saikrishnag@marvell.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Sunil Kovvuri Goutham <sgoutham@marvell.com>;
> Geethasowjanya Akula <gakula@marvell.com>; richardcochran@gmail.com;
> Linu Cherian <lcherian@marvell.com>; Jerin Jacob Kollanukkaran
> <jerinj@marvell.com>; Hariprasad Kelam <hkelam@marvell.com>;
> Subbaraya Sundeep Bhatta <sbhatta@marvell.com>; Ratheesh Kannoth
> <rkannoth@marvell.com>
> Subject: Re: [net PATCH v2 5/7] octeontx2-af: Fix issues with NPC field
> hash extract
>=20
> On Fri, Apr 07, 2023 at 05:53:42PM +0530, Sai Krishna wrote:
> > From: Ratheesh Kannoth <rkannoth@marvell.com>
> >
> > 1. As per previous implementation, mask and control parameter to
> > generate the field hash value was not passed to the caller program.
> > Updated the secret key mbox to share that information as well, as a
> > part of the fix.
> > 2. Earlier implementation did not consider hash reduction of both
> > source and destination IPv6 addresses. Only source IPv6 address was
> > considered. This fix solves that and provides option to hash reduce
> > both source and destination IPv6 addresses.
> > 3. Fix endianness issue during hash reduction while storing the IPv6
> > source/destination address as hash keys.
> > 4. Configure hardware parser based on hash extract feature enable flag
> >        for IPv6.
>=20
> Hi Sai and Ratheesh,
>=20
> there is a lot going on here.
> Could you consider breaking this up into more than one patch?

We will break this patch into multiple patches and submit v3.

Thanks,
Sai
