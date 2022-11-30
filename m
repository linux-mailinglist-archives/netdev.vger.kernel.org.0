Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A00263D127
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 09:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235123AbiK3IzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 03:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234098AbiK3IzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 03:55:16 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77992D1D5;
        Wed, 30 Nov 2022 00:55:15 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AU1OxDn021177;
        Wed, 30 Nov 2022 00:55:00 -0800
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3m3k6wf003-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 00:54:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kdH3hXb5yEeYaCdGm/R5yx+zHO2s4w7zkCIk7b0/qhIYu4qFXwm3MHB3A6zYD41Es2mf/y8AbSawQsQbtQ4mW1kuA8BzJ1E76liuXpRfJkp/NF/cAozwMiHzEJyCOIK4Btmw/FXbfz6ptFo/1smIWnKCoMADOffWHlBTS/C61wQMm7NNDjES+LE+rbPB1XCwiUJCkF8FR8lM++KHY8ltVkI2cw95ndjO2R3yCKuF2RpGOOpp74rvchSUrqvuVdgBrAeZXCbA23vjWuX5sRMRI2LTJMatrhJeO5sLBoqUx7xKw9SvELIfL/8fKQH1WaW/pRAVIQeWq3V+Q8EDrmFNgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KkdH+e+TzTg8r5ibhEn5NjL7yq/FUrHJIzZDlnQlNJQ=;
 b=dnJH0S01UmrDgxc3PjShcCNP4KffSTQ+NLZuqd0EAEObBnUDLEzAtse4n5YkBPqy9LqLuPdRb+z0ByCavjZvN9gim2ocRow9pHksfS90viwz1SysLBbweeQcI3YIUwqnQWRxIbkT+fUPlp2V8UxbN2u4GKZSzb8PZI2yYN8JE+S8RgN6PA0vLaH4GqHiivR4MxZAoop66Qz0lK9IOoXDf6yWyoobM6gZ8nG1RBvIGd3HzkB4hNYgSazGaum1zGEorQynIrE2h1Ozyk7f/yjAqDfpriDxie1pzI30WW2dUgnFDsDY3rSKxLo3xE6MGkV7WAYgrna8KGMiwVl+VouV8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KkdH+e+TzTg8r5ibhEn5NjL7yq/FUrHJIzZDlnQlNJQ=;
 b=XlytsEldZ1UnPjaK7n8Z5wL1ravzKhOIew7dZEcQeFp28zKmjBjZl1X/TAeMz/2zjWO8ZzLwt0rGzWr0q9UVMoAcGtM11FobbtRKq9sSw8/5ZPOzaIoteqMEVysZhdXsfp8mrHb7EDAPRTFwHJbo2SkqUAvbDifOxirg7g8h3Os=
Received: from PH0PR18MB4474.namprd18.prod.outlook.com (2603:10b6:510:ea::22)
 by SN4PR18MB4838.namprd18.prod.outlook.com (2603:10b6:806:21d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Wed, 30 Nov
 2022 08:54:57 +0000
Received: from PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::c182:14c1:71c3:a28f]) by PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::c182:14c1:71c3:a28f%8]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 08:54:56 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [net-next PATCH V2 3/4] octeontx2-pf: ethtool: Implement
 get_fec_stats
Thread-Topic: [net-next PATCH V2 3/4] octeontx2-pf: ethtool: Implement
 get_fec_stats
Thread-Index: AQHZBJlrNcjpjaBwqkqGOkY2mLdbJA==
Date:   Wed, 30 Nov 2022 08:54:56 +0000
Message-ID: <PH0PR18MB44747D2827AF30B2484DFFBBDE159@PH0PR18MB4474.namprd18.prod.outlook.com>
References: <20221129051409.20034-1-hkelam@marvell.com>
 <20221129051409.20034-4-hkelam@marvell.com> <Y4ZTSh7/xCJVosyW@lunn.ch>
In-Reply-To: <Y4ZTSh7/xCJVosyW@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcaGtlbGFtXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctYTcxMzgwNGEtNzA4Yy0xMWVkLWI2YzItZTg2YTY0?=
 =?us-ascii?Q?YjVkNWQyXGFtZS10ZXN0XGE3MTM4MDRiLTcwOGMtMTFlZC1iNmMyLWU4NmE2?=
 =?us-ascii?Q?NGI1ZDVkMmJvZHkudHh0IiBzej0iODQyIiB0PSIxMzMxNDI3MjA5MzI5Mzk5?=
 =?us-ascii?Q?NzgiIGg9ImZUeFRmdnRUc1Bqbnd3MHp5TVFGNWZ5d3pBOD0iIGlkPSIiIGJs?=
 =?us-ascii?Q?PSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQVA0RkFBREtD?=
 =?us-ascii?Q?S05wbVFUWkFiUFZkbURFNmM1anM5VjJZTVRwem1NSkFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFIQUFBQUNPQlFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFRQUJBQUFBK1JHOGVnQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFaQUJ5?=
 =?us-ascii?Q?QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFCekFIUUFid0J0QUY4QWNBQmxB?=
 =?us-ascii?Q?SElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFB?=
 =?us-ascii?Q?QUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFYd0J3QUdnQWJ3QnVBR1VBYmdCMUFH?=
 =?us-ascii?Q?MEFZZ0JsQUhJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJqQUhVQWN3?=
 =?us-ascii?Q?QjBBRzhBYlFCZkFITUFjd0J1QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHUUFi?=
 =?us-ascii?Q?QUJ3QUY4QWN3QnJBSGtBY0FCbEFGOEFZd0JvQUdFQWRBQmZBRzBBWlFCekFI?=
 =?us-ascii?Q?TUFZUUJuQUdVQVh3QjJBREFBTWdBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWkFCc0FIQUFYd0J6QUd3QVlR?=
 =?us-ascii?Q?QmpBR3NBWHdCakFHZ0FZUUIwQUY4QWJRQmxBSE1BY3dCaEFHY0FaUUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFB?=
 =?us-ascii?Q?SUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFIUUFaUUJoQUcwQWN3QmZBRzhBYmdC?=
 =?us-ascii?Q?bEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFCc0FHVUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdV?=
 =?us-ascii?Q?QWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJQVpRQnpBSE1BQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dB?=
 =?us-ascii?Q?YkFCZkFIUUFaUUJ5QUcwQWFRQnVBSFVBY3dBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: QUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBQT09Ii8+PC9tZXRhPg==
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR18MB4474:EE_|SN4PR18MB4838:EE_
x-ms-office365-filtering-correlation-id: a8f92e31-7470-43a7-1894-08dad2b08e26
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H0dyD++kMzupWVRYEwoDxAIIMZ1mRA1UJtUMQqXGrvgyqFLGXmG1msJth9bK5kV0hSj1iqOXx75JvvYtFN5Fa5tGRRAb7EgrZMmTWsyHRUpU+vjxWYarT6wmmk2mzTDqvVixQnYQMJbAV9waYrabjjuMFP23LW6n5irxBO5yMkolWz3RXCx63GUYzKC6v2a5b1hWgq/a/TRzP0DtId6RSOR+CCbwKVXBnpz97gPN10h4t789eW6+ctrdpP90sk75Iq1NJq8t+6DlX5DwrxQT3dUojXDfA07vBelzKrdSXvfgUJQPTRATDTckxJS4rlwoREhtQAbtTvQbgM5Wt21jk1NsA9dN8G5jPyHjm8L2F4MoKwBX3/qgxINZCqsJwOAc874fo6OL0UZcjCM2PgZ9gcCFers1jbISPyUIpSE+UeQfPSkw9t8EX+0iUu5IqtQDfVRgBvMExb8YAgFQGoDSKGjBPvPKcdrMfHldlI79QMQeLebehCviBD7B8M3xtI0jeZJSPOF6rHr+iaXpGpXLIOP+4MmlEdebCRYEoMqGEbhq8cwDqN6uFqUOTKe0p3tA62YJ5g5lo6f1rod5Uz/tJc9Y8H8VBEAsLRmeWojSD2cjNRPPVaW0tAM2EWyLIU4MXX01sajd75/6//K1lpRwtaXMAp2tWT3aZyni9bvXOvxDJBRqAhW54NEpzoyEp4fv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4474.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(39860400002)(136003)(346002)(451199015)(66446008)(8936002)(64756008)(8676002)(5660300002)(4326008)(186003)(26005)(9686003)(52536014)(41300700001)(66556008)(54906003)(38070700005)(6916009)(4744005)(2906002)(33656002)(122000001)(86362001)(316002)(478600001)(76116006)(66946007)(66476007)(38100700002)(7696005)(6506007)(71200400001)(55016003)(107886003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?n2D+jTz9XtGF81Tcvllh21XGnycDVul+nhD6l6IAmJitHo8E8rhf10XyW9Bx?=
 =?us-ascii?Q?EFr7jdKh2b1l4uriQMe2pEd3zITrne56I+vhHSJdBYw1ihiXwdgIHuUXV15b?=
 =?us-ascii?Q?NK66MoWQmXdU8zbnLpfZnbCX6j2OTlTJX9BfnFMz2v5dmm5Y4rKch+Wlw75+?=
 =?us-ascii?Q?assOHnLoszqild2SZRHoxeTX5oiCVbsjAUZO1HEqZq6CAvu4mfjUvQPTnhjw?=
 =?us-ascii?Q?wkX0TNnvyCGufVYQH0z5ix79QeRboGOcJ9fukAhU4nylxV0Wl66CzxIGyjbH?=
 =?us-ascii?Q?QO1lkB4l04B6RtyBhPhW5VHpfUutrCmK5n/c5xj13eAnx9YiVJcd9UQM5N+A?=
 =?us-ascii?Q?+tZnMf3u/s4h8uGPyfBNZg5eiIkcU/R3X+Yx9cAgu5tP5gX4aq2XLneQOW59?=
 =?us-ascii?Q?s4VTe9IZpd7HmQMeQHNu+zqHzmS99SB9MZDMFgoyFvQY0LDBoXAxgfIs7Av0?=
 =?us-ascii?Q?iM4A/h2sdtxU9ArvGLJn6UrlLmivbT2JTD45cDI6aHwTUME7XHWH4GFs766w?=
 =?us-ascii?Q?0G4d51j+Fexh+hnYyDFoOD08G/y4Evx5K5oqJk5SJsFxEhiY3gkwluOZSH5A?=
 =?us-ascii?Q?/Rg04xAHHlRjDThshQki0eUksCP+vfKUrwfvCg+jii93xJRB4LW1GtFCh+UE?=
 =?us-ascii?Q?zyBYr3GbwSCvGVfYSHaq0RqFVg3RbwdHukRMZMgT+HM8hvR9+/z6EV9/8eYD?=
 =?us-ascii?Q?aqvr2XMoDBnTu+ZBsOBHYwB/81vT4K9ZTU00jSK7TE7ng9hVMt7edSAuddoL?=
 =?us-ascii?Q?2bUImBzlBuiS7zWgZQwQYZO13f3AGzU7UEsHdw01jbup0I4js3iSCOIC0BMd?=
 =?us-ascii?Q?/iJXi8P9a8SI4Vd3vZ1zhVp6upFdut0P8/V5i2iMxElx94zYj6ge6WNC7vwx?=
 =?us-ascii?Q?20ArZpGyGIwEm9QV+JBBt5ybg7AnO++6AkgtkLfmrVhq10FMbwsl8kSeWxMs?=
 =?us-ascii?Q?BLAFVnV5adsZI4i7zZjyBJ0iO6tl4AajalO4OwTpFY6E9EFhd4o/Phes1cXV?=
 =?us-ascii?Q?uSr2GmbU/HHsMEMF0kIAg0t2z8EQUiaOp7UgGxOEmRP7q7CA2mXVjz9QLN6Y?=
 =?us-ascii?Q?NOkxABZ+JRoZrJKMneZqf4ORY6XEobzsWdH0UWFZlU4ncplc6p4ccwqC/uWK?=
 =?us-ascii?Q?U/fs8n+QYElSORdfe7dRSDreYYi+5pIejjn+1HorsRgL3xRg85e/Qvyg5Gpv?=
 =?us-ascii?Q?MBmlWfYY/W9HUVLP/u36FMdyYeoAeYppjYssKgEWxSnTHaoiZoH+TtR5SEEi?=
 =?us-ascii?Q?O4jF+zNGIRGvAsz/i2yeGGPD7jxv/Ga4KY5416PI0bp1J0xwwk07rrcatTOK?=
 =?us-ascii?Q?M5S+8LUfk8RVM2zln7yT0r2oBTvAu4ZNgIcXUjkjU0XcQDQT4pmUKqmnk8zB?=
 =?us-ascii?Q?MFRUt+qyMn73Yd/kg5pf1g6XWFIvE5ViABF3oFBNP/EImWCxbmwe1SSlzHkm?=
 =?us-ascii?Q?vFUM0VXA0fURyrQKuwuD4VAcamKTFw96Y/pmSg24lswum/sXzj5yw0mZhPmN?=
 =?us-ascii?Q?AdCY8tkbrmVRjce0uCmHsZ9ydOJl01Qyhx2U6T4myxoFaul2Zkd4KDT4rfg1?=
 =?us-ascii?Q?HhcFfsWYC0pdl8JbNpM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4474.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8f92e31-7470-43a7-1894-08dad2b08e26
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 08:54:56.7128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aWur0kqGp/YsRU21VhSGUqIAsZmHHk322YlAaO07Y3cnePZAba7136eVeM0aj0cbEji+wWXl9m4clFHADqig/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR18MB4838
X-Proofpoint-GUID: 5cvQSCIn-sJ_GmpPPGpiyuTGZM6-8k0C
X-Proofpoint-ORIG-GUID: 5cvQSCIn-sJ_GmpPPGpiyuTGZM6-8k0C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_04,2022-11-29_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Tue, Nov 29, 2022 at 10:44:08AM +0530, Hariprasad Kelam wrote:
> The current implementation is such that FEC statistics are reported as=20
> part of ethtool statistics that is the user can fetch them from the=20
> below command
>=20
> "ethtool -S eth0"
>=20
> Fec Corrected Errors:
> Fec Uncorrected Errors:
>=20
> This patch removes this logic

What might break the ABI, if anybody is using these statistics, or has a du=
mb parser and just looks at entry 42 which is now a different entry.

So i think you need to keep these two, and additionally report them the cor=
rect way via get_fec_stats.

Make sense, that's a good point .
will wait for a day for other feedback and submit V3.

Thanks,
Hariprasad k

    Andrew
