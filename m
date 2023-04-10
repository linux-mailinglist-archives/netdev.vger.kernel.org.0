Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACFF56DC446
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 10:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjDJIZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 04:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjDJIZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 04:25:38 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E9830C8;
        Mon, 10 Apr 2023 01:25:38 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 339NwC2w013012;
        Mon, 10 Apr 2023 01:25:29 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3purfs40na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Apr 2023 01:25:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GS0WOQN/REqB097XoSEbVRowdPkYiiM+Pzeq2l0w1wsZBK4m87jEaRLCzKU+BdCcZ/Qt0y8ynbVksw+ByaGuDmHk0CbPp1xYOnjLFaWC8qr7JVOpwloKo60PrT/9YGnb0d5rR4kQiEyvSYMleM5hsqybrWVpy24eXhlgWZEMh6Pgz7wwMxW0S+udhIixLUOv7o/zIO0RU5ttR0kLazlg6LTv3O858Mqa776b7nKGKXqrfaBUayMg6bjaQHvblBw9BhQsEhp1WgrRBF9rnzmBDE6Sq7fubMRonG7qWxC0ifHucBv4gxmJkhXLrAB9H6FCm7DH8QPCVbrMLDNQke0ATA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C/r0d5w9GpiBHotOqD/DPVnQaGQ8HYsbawrk0wlhfJk=;
 b=Q9BWCZ0eAoXEMsPEFjX/3f4RJIU3zx/8cndzI0gn2ElF3gaYP5yqzpDd+DDtUcaTifTmJZQfTm2EMNhxTCRzTe09H7jGEG4YRQ65lGnt1oXPmr5FtcdT+75YQ0t9EzGE4w53ArYfOVx4BgtaAXUR4U1gsMs2lEoffehffg1CA/oG+8ydQx1JhfSmcmpYvnhmivM2XV451axo3VBc7464fFodJ9IVDGpAUH23drfgUSv2yIGPFhM9qZVyGOP4rcIXEkaWyMjzUfZrFSkqI30V0UM+LIK5L7EAUrk1VER6quJbKGO+YEmImERKenTBC75N3XOdidQ5WxjUwZ970FhHVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/r0d5w9GpiBHotOqD/DPVnQaGQ8HYsbawrk0wlhfJk=;
 b=L77lh6Z1CL/6t6VKs1SmiAKtMor/g0LzHo33GZsKajGJayv66t5O5ZM34xxZCt2z8ID6gOcVTmEB7JtwdEscD3gXaJyUeNfHhHoQU+PU7ad9/tSlhlUJgx5obiDFDibrVdRUQXZqeUo9xmc2HK09M1KaKTQCAv43rDPFt5LJxcs=
Received: from BY3PR18MB4707.namprd18.prod.outlook.com (2603:10b6:a03:3ca::23)
 by MN2PR18MB3461.namprd18.prod.outlook.com (2603:10b6:208:26f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Mon, 10 Apr
 2023 08:25:26 +0000
Received: from BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353]) by BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353%4]) with mapi id 15.20.6277.031; Mon, 10 Apr 2023
 08:25:25 +0000
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
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [net PATCH v2 1/7] octeontx2-af: Secure APR table update with the
 lock
Thread-Topic: [net PATCH v2 1/7] octeontx2-af: Secure APR table update with
 the lock
Thread-Index: AQHZa4YA3A/K+/IfKEyu2wpVnbE0nw==
Date:   Mon, 10 Apr 2023 08:25:25 +0000
Message-ID: <BY3PR18MB470732BB43D8D9EF34CF7434A0959@BY3PR18MB4707.namprd18.prod.outlook.com>
References: <20230407122344.4059-1-saikrishnag@marvell.com>
 <20230407122344.4059-2-saikrishnag@marvell.com>
 <ZDF7KFavZuM2SoGO@corigine.com>
In-Reply-To: <ZDF7KFavZuM2SoGO@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2Fpa3Jpc2hu?=
 =?us-ascii?Q?YWdcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZi?=
 =?us-ascii?Q?ODRiYTI5ZTM1Ylxtc2dzXG1zZy0zY2IxOGE4ZS1kNzc5LTExZWQtYWQxYy0x?=
 =?us-ascii?Q?Y2MxMGM0MGQ5ZTRcYW1lLXRlc3RcM2NiMThhOGYtZDc3OS0xMWVkLWFkMWMt?=
 =?us-ascii?Q?MWNjMTBjNDBkOWU0Ym9keS50eHQiIHN6PSIxNDIwIiB0PSIxMzMyNTU4ODcy?=
 =?us-ascii?Q?Mzk4Njk4OTYiIGg9IlVFdXhzN3dSYm0vMkJlSW9saFRlYnNWWGlJQT0iIGlk?=
 =?us-ascii?Q?PSIiIGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUhZ?=
 =?us-ascii?Q?SUFBRElkU24vaFd2WkFjc1A4VWlsY1owYXl3L3hTS1Z4blJvTkFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
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
x-ms-traffictypediagnostic: BY3PR18MB4707:EE_|MN2PR18MB3461:EE_
x-ms-office365-filtering-correlation-id: 07db7b8a-99a3-4d89-c66f-08db399d2299
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dvXW+ACVsu817si+UygZwb73/jCE6o4jJZFzPUQ/Pb0hDs+wzzslLEYW/prZQ6HorySJ7ggbggfnnCq1O7vHycDuRqeMnSKYnU4H4RFC8fC+yyKg0mh5Kw/xknJzbfmg54TmbZabgSt+rcPJU6nkvRSyAjBoKD6ffkGdH8Uhx+MgsDYIarwiUCgEDXKeUGyr0ncgqTw2ZbvFq64Kyz0gSjVhA6KeVcFdc4Gr6RZ0RuFkv+5+mKt1cB6tmCjNfyD93wYvNG2Lrtsixl+6A3cviptaUuCMHX45+wrmPsiLxi9D6rm6Mor407uqJE1ve9h5RzSlkaUidhyYECx4LQHB3sN4tH11wT5G8Ayblbn6/0JBX5m0uN6I0cdh1WzhXH3GnvezN9mWfwruURrsEb8enoDoEOh7u/QPbW7JJz0d+XgInHHVOVPRR25cjKmPB8GH28xFosgJKmQe9OnGYnftUVC+huBGVC4QH7BHjQyyYydQnvRpoY4Vh57rd1t08WlcW4A8QHN1aRUWTT7Wfy+q5370fh7gUPpWg/sANmXJfy+atXkano+NvHTHoNYzwj53q7w9Phgfvm9P8eUSTZDP/VfYwopp7TJ5J8pbM2gUK4IWMjKQ7YCXGLyZdVWCGc2B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4707.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(136003)(396003)(39860400002)(376002)(451199021)(478600001)(7696005)(71200400001)(316002)(54906003)(53546011)(9686003)(6506007)(26005)(186003)(107886003)(2906002)(15650500001)(66556008)(4326008)(76116006)(66946007)(8676002)(6916009)(41300700001)(8936002)(64756008)(5660300002)(52536014)(66446008)(66476007)(38070700005)(122000001)(38100700002)(86362001)(33656002)(55016003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4SomzjU7Y0jozWIbXVW0hyO7P/I8j3M7hn1GSMpRzSH+yw2kwt8z0cMd7f6B?=
 =?us-ascii?Q?d7jfBsDq++VWIzjXxxDGl7c/g7YsQ09Qgy5zJ0ZbEY3CgztRPZVa1LluWjTT?=
 =?us-ascii?Q?guPwU30oe5JFLkUwR4RaLMNI+xb6anysxO9UWOyIme7TBWcywVDWiSfw23VR?=
 =?us-ascii?Q?nXPXpRoACjwtDxSMdJwaupfjMrIiwVx8a7Z2HFT4ZO7EFdxs1Ptmqkrb6VcD?=
 =?us-ascii?Q?9Q0QUi762j0+kRGvSNdf2q+FxuWaYpiOUceV0cDjl4HlDVAE7b9kmq9HmLWD?=
 =?us-ascii?Q?Oe5HTI2GuG/fmEd5g2dUTBCK4N93wC5MdnGSH6t5Ss6GYC5sW3/OfV67vF6N?=
 =?us-ascii?Q?vHFiTf9Oc0eH+aX/Nr1jSZXND2P0s2Gc4HssFHFAwB8X0SgVQoiM4elgEW67?=
 =?us-ascii?Q?qLNHFbhKAxGB6TbL6Qvv90uYoA/Fmmjg1K8p/HnuAtIsTLygzKAMityrRwE2?=
 =?us-ascii?Q?89aiRMlwo4MDEEld/XhoiUNjcrjJ+lZ46d1IZ+ckvtRti45s3j+PbCOeP5Lx?=
 =?us-ascii?Q?AydRPA3hVzku4+LIOI32/JoX3qNy+p/WJx3nl6lvY8rWp0gOO8/4MSAs5a8O?=
 =?us-ascii?Q?yIp4SVXTkgWcah1RcnmTJIlzXvD4ftBW+TUMnVbKbNfFNsP2nTe1ZcLoND24?=
 =?us-ascii?Q?wNtnLj9L1GbB7Fhh6PVH4cIPxILKdURK3nYKva3fic3bWhK5Yopstjx4o05C?=
 =?us-ascii?Q?nvk/GNv7W3d3C3rnJUSGk3JXQX6vTd2XDUmH5Y9SM2V63iKynrQHeLaHRxnk?=
 =?us-ascii?Q?SR46BF7BPR1Z1jO4k8fcupZ0L2/MD5TERpzAhhfSQQdVfQxw2Cg0clX4usuu?=
 =?us-ascii?Q?OSBkk4CsTTOheGZAwKA0x8E+Zx5ICe1W2XDzp9MQmW4oMgrbN6ZWx34feZH5?=
 =?us-ascii?Q?EduWV8+fyv1cbf6jzDBWmrmdWwQcoB3Q4LtevwSfjZrMsrM2ESampMJSM6Mn?=
 =?us-ascii?Q?4CQZQIsPw04zlGifn64dhM22xesMgk5r26ub5RTE2dDIfuiJvhPooKjgbwCW?=
 =?us-ascii?Q?FLm4mgvW2TiZ1MPAXXopRknt9D4hL9MURpUT8+RCx8hawKsS71bAe4SWG/nQ?=
 =?us-ascii?Q?eFTUTQrgOsXwgUZOjwak+bHb3KRracolnpSmlVuGosJUs7LRhSYP8cDRdILV?=
 =?us-ascii?Q?scY6SCszG4hUtbgq0+Zsf2b3YJG1OoLv1Ta0ryFllq9MD05Mabfj0F5GNebC?=
 =?us-ascii?Q?9jcCAu/jEUONHN8pr10jqKmJoI+sOR5BnG+GD/0/3TMfhSDhsYLx/mvcn7aQ?=
 =?us-ascii?Q?m5komuwkYCUCRKet9vIZI7jA4Pjk7vy2JVEgFx1MTXeFFshOA88rR5mPACSJ?=
 =?us-ascii?Q?D9/nIo0/WlsetXI+lwu5i9Kkq1hHOPlJ3vP3rqZFBO0D2Nsfr/OdeR0pKneK?=
 =?us-ascii?Q?xewkTfDw11gfUQZLUgcDhKKhGQzup3POY2bfGMATyQfTc7Fsfl7owdL7UF3K?=
 =?us-ascii?Q?b20oKUg8K+j6dScblSA1pNBG1Lzv+f1ybeYcgo1pcQB+Azn0zjU8KPSBhJBH?=
 =?us-ascii?Q?UkBUSlIG7WmoD8u51Kn8CVSvughHtKZn6/RxlkjCPAjJq8I5w0puaIEpD6ZC?=
 =?us-ascii?Q?runoyzyTHd/q6YusDjB0jw06j8NUOv5NNL6ChZtd?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4707.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07db7b8a-99a3-4d89-c66f-08db399d2299
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2023 08:25:25.5731
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 37VgMIxePVT6GmdqTQzPdmawbtQZoWUxQNkVd9Ku0zlTID9v4XYEldJSZE57M9cjhCmmAPwWXbijXCCkceKr8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3461
X-Proofpoint-ORIG-GUID: 1Db9AvLcE-8Two3thTAwrY5BzK_ubutj
X-Proofpoint-GUID: 1Db9AvLcE-8Two3thTAwrY5BzK_ubutj
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
> Sent: Saturday, April 8, 2023 8:03 PM
> To: Sai Krishna Gajula <saikrishnag@marvell.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Sunil Kovvuri Goutham <sgoutham@marvell.com>;
> Geethasowjanya Akula <gakula@marvell.com>; richardcochran@gmail.com;
> Linu Cherian <lcherian@marvell.com>; Jerin Jacob Kollanukkaran
> <jerinj@marvell.com>; Hariprasad Kelam <hkelam@marvell.com>;
> Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
> Subject: Re: [net PATCH v2 1/7] octeontx2-af: Secure APR table update
> with the lock
>=20
> On Fri, Apr 07, 2023 at 05:53:38PM +0530, Sai Krishna wrote:
> > From: Geetha sowjanya <gakula@marvell.com>
> >
> > APR table contains the lmtst base address of PF/VFs.
> > These entries are updated by the PF/VF during the device probe. Due to
> > race condition while updating the entries are getting corrupted. Hence
> > secure the APR table update with the lock.
>=20
> Hi Sai, Geetha,
>=20
> I think it would be useful to describe what races with
> rvu_mbox_handler_lmtst_tbl_setup().

We will rewrite comment message and submit  v3 patch.

Thanks,
Sai
>=20
> ...
