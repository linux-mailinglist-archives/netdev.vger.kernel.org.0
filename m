Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847286EA357
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 07:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbjDUFvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 01:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDUFvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 01:51:19 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130EE269A
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 22:51:18 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33L32vQw008042;
        Thu, 20 Apr 2023 22:51:08 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q3djpjc4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Apr 2023 22:51:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bxb0Ju7XVYNKJfHsoRY6Sb1ryT0jU3vZL5jc3gPfIp8PeJoEGt9rWCL6LtSmh2ZouqURLABflWiFQIpp+c5ma17HhJBG5MnpZOzwwGcARglelDp5EMXtkUXr+bXGsuoLAWyKcodYyBQBLSCZZmZYB5KaoDWWqTHr8L6glatUgi8gHNrz3hqhSe6NeRBf0aLo0d9UodbI9yhHv64z72wH4nap85unqS/IdOaxoj3U2n3a4Hy7Bbn4LQqcWn/3x3W8EfArB9PK9SUA/LfZpKi9Y7rNAJL5ZvIJVXqAh/r0Eu/gco8vSKhOK5cO7y3gNUz2lq7WIbbRiSeGIIKFRyFd8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NqxC7O+ZmWyEb7JStsmSMevmJ1lHrOOzq+qBfKeark4=;
 b=WwCMxpTmqt8Cobuti86HPd7JRgB4rNro6P1qZKbD5AxFN1BfvrBsIVoTo5+uzYF++sDCll928M3FBp6qBg62iQZUYl3UoDFinBt+toYGz8J00Sk1Cz73iPjlePvVIOqOt80NBI+l06Ev/0bEvnG7bJgmgAce9OUYoSHhp0vzQtOxRmaYLUY82aqLJh8KRWNKh/rH+fey9S9guls4cmPquR26fiYNjuCVg9aQFA+fTfNp8MXo2URqDPBrcwsxytifKpwsmx5Bn00NgCyo53AQu8o94gsMNMQphcyF3ZXb+hj2d804CNjBtLR4JBpjw+46s3GCh1KWDBVFUoz6lwFHOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NqxC7O+ZmWyEb7JStsmSMevmJ1lHrOOzq+qBfKeark4=;
 b=OCVdad9wpFfvg0W2INL578e59tQZGRovkVBOFRifV+ORzeI49WkXZtVjwzkBSToC6jw3MpBfyt4p1m68NpQBIyzJNTI93mbccD+G6VAIA5SIYI7vo0vRxFAmvHSuHWp1xQq/VhVP5VJ3zaDpCdwxCPiRUhgaWRKe+t9ioP4B7lg=
Received: from CO1PR18MB4666.namprd18.prod.outlook.com (2603:10b6:303:e5::24)
 by CY4PR18MB1397.namprd18.prod.outlook.com (2603:10b6:903:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 05:51:03 +0000
Received: from CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88]) by CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::ead5:44bc:52e0:bf88%5]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 05:51:03 +0000
From:   Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
To:     "ehakim@nvidia.com" <ehakim@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: RE: [PATCH net-next v7 1/5] vlan: Add MACsec offload operations for
 VLAN interface
Thread-Topic: [PATCH net-next v7 1/5] vlan: Add MACsec offload operations for
 VLAN interface
Thread-Index: AQHZdBSnUiJu3Z4fNEq3imE6l3+pM681Qlag
Date:   Fri, 21 Apr 2023 05:51:03 +0000
Message-ID: <CO1PR18MB4666E85002C433E813BF6792A1609@CO1PR18MB4666.namprd18.prod.outlook.com>
References: <20230419142126.9788-2-ehakim@nvidia.com>
In-Reply-To: <20230419142126.9788-2-ehakim@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2JoYXR0YVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLTdjZjRkYWEzLWUwMDgtMTFlZC05YzU5LWJjZjE3?=
 =?us-ascii?Q?MTIxOGI3YVxhbWUtdGVzdFw3Y2Y0ZGFhNS1lMDA4LTExZWQtOWM1OS1iY2Yx?=
 =?us-ascii?Q?NzEyMThiN2Fib2R5LnR4dCIgc3o9IjgxNiIgdD0iMTMzMjY1Mjk4NTg5Mjkx?=
 =?us-ascii?Q?NDgyIiBoPSJPMzVSNnJ3U3hjYUNmUnN3K25HV0tKNXF4L3M9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIWUlBQURh?=
 =?us-ascii?Q?RTAwL0ZYVFpBV3NDeDBrN0tpYythd0xIU1RzcUp6NE5BQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFBR0NBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQW85aWpmUUFBQUFBQUFBQUFBQUFBQUo0QUFBQmhBR1FBWkFC?=
 =?us-ascii?Q?eUFHVUFjd0J6QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdNQWRRQnpBSFFBYndCdEFGOEFjQUJs?=
 =?us-ascii?Q?QUhJQWN3QnZBRzRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBBWHdCd0FHZ0Fid0J1QUdVQWJnQjFB?=
 =?us-ascii?Q?RzBBWWdCbEFISUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCakFIVUFj?=
 =?us-ascii?Q?d0IwQUc4QWJRQmZBSE1BY3dCdUFGOEFaQUJoQUhNQWFBQmZBSFlBTUFBeUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01B?=
 =?us-ascii?Q?ZFFCekFIUUFid0J0QUY4QWN3QnpBRzRBWHdCckFHVUFlUUIzQUc4QWNnQmtB?=
 =?us-ascii?Q?SE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFY?=
 =?us-ascii?Q?d0J6QUhNQWJnQmZBRzRBYndCa0FHVUFiQUJwQUcwQWFRQjBBR1VBY2dCZkFI?=
 =?us-ascii?Q?WUFNQUF5QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJqQUhVQWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QWN3?=
 =?us-ascii?Q?QndBR0VBWXdCbEFGOEFkZ0F3QURJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?UUFiQUJ3QUY4QWN3QnJBSGtBY0FCbEFGOEFZd0JvQUdFQWRBQmZBRzBBWlFC?=
 =?us-ascii?Q?ekFITUFZUUJuQUdVQVh3QjJBREFBTWdBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWkFCc0FIQUFYd0J6QUd3?=
 =?us-ascii?Q?QVlRQmpBR3NBWHdCakFHZ0FZUUIwQUY4QWJRQmxBSE1BY3dCaEFHY0FaUUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFI?=
 =?us-ascii?Q?UUFaUUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFC?=
 =?us-ascii?Q?c0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFB?=
 =?us-ascii?Q?QUFBQUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJ?=
 =?us-ascii?Q?QVpRQnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQURBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFD?=
 =?us-ascii?Q?ZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIQUFjZ0J2QUdvQVpRQmpBSFFB?=
 =?us-ascii?Q?WHdCakFHOEFaQUJsQUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCdEFHRUFjZ0Iy?=
 =?us-ascii?Q?QUdVQWJBQnNBRjhBZEFCbEFISUFiUUJwQUc0QWRRQnpBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQSIvPjwvbWV0YT4=3D?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR18MB4666:EE_|CY4PR18MB1397:EE_
x-ms-office365-filtering-correlation-id: 077f57f1-b252-4601-f41c-08db422c6456
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gNFH2NCkxlZG+Gh09fPf9/9phf2k9TmUAH8XRAx51wlP5tZh24Hk5xnunxsguupajmWJzP+05cYRLecbluSeNKUhOP3MhU0bFhXl6zDm7o8Z7zmocJkCqI6Dew5tDQsIBefUcOzXSx0AKn33q7KVr72sxwKnkmeCesbt5EnOI6hX1qLYQR5ef2oS0mZMwDzmJOLng1Qyroan09tu8Q43OVdEsdnvYv2Kc5CsbdRT4/KtzWRDrBsEeQsStp0Y9zzfuItnfQxQDvHkXeSrCsjWPrTzvjgwI0OWji/WNVe3kAM7lGwD0w/ryJhq945hLeZlEfvHyffHXao9Qr3zlOQJE/TFaQ41u5MQ+4+SRdFZU3qLclR9QO+NrLraohEPOoV/9juybYacdkoSs1eLy9n9bV2GEWRzRRup2qbxa1EMUOfHQVbB6F0wRrxKkf45qfZnHB5n5YWMMW31/me5PuNQ+ptrJSQlN4M8YekA62W85gk9AneyDG83IYYTDfiwRaJ/hwI9eFhJ5KFG50/ut7dxJp2xXhpiGItpAfiu3/imIBcMvflwV2P/M9q3bHjZ6Pp2NLfurinnPiRjaHfTJ9uN5HPCpTciZZkbPaZW9MGFIoM1/YzXLFvhZBZ2Oj1HoVlr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR18MB4666.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(451199021)(478600001)(54906003)(52536014)(110136005)(8936002)(8676002)(38100700002)(5660300002)(2906002)(4744005)(38070700005)(86362001)(33656002)(66446008)(66476007)(76116006)(4326008)(64756008)(55016003)(66946007)(316002)(66556008)(41300700001)(122000001)(9686003)(186003)(6506007)(83380400001)(7696005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4KVIWoJcRMvwuKVj8QU5+Tp0d3UoP3XgqA/eSuDggjvZq8zCkmq5wTkzcUiW?=
 =?us-ascii?Q?jKSPVxzWk6faVmc08vZP8pRl7GU1Zcjdo3JQK6gWa22RqMp+rYzQwG8dcAUK?=
 =?us-ascii?Q?y9oSVRlqV3k/dcLaR8nNQHRcLFy4lo86wpK4BxDOTzZ1qSjCa9fW61DTo7LQ?=
 =?us-ascii?Q?J7Bm9tkh51A3tB+pitFgH4PDl19ryy3rqjHG8e2AmdXCfhpaCy2P/RiAUQCR?=
 =?us-ascii?Q?u2JiQ40zJwknS1c9k3ERitlehf63XbbPkbZ1airTGFx3ZHg8pUU1OqEQZOxV?=
 =?us-ascii?Q?WY/nErDGuJkT6ARWaLClDjSd7BUzb9XA6i0aXikv1NNSy7tZ1pmWHFd6zpCl?=
 =?us-ascii?Q?ZrCdLqagY3tuZbBkBrnmN28eBqG5fkzmhOqYrkc7DHed3GdQDjt3+PzYMgNo?=
 =?us-ascii?Q?2FjLVlJFX6THXPGq7/giMFtejNqNhCb7S8kGctG7zog2zreka3i3vmeOCmjF?=
 =?us-ascii?Q?naDX4iNhuauMOCi02Pi5Hu1+2M1r6mG1gXVtkqy47R3YeUtg0a6pRp5+VQlY?=
 =?us-ascii?Q?6nV/5UICpstrWmG9vTqBLPWnV+1TD42POhs3z6ettK+27Q6SoVz8KyGNBNRh?=
 =?us-ascii?Q?p/bdbF4puhtxc87V7yjVHFhrnxn97JpFsol0IzOCZX1ngRUJ4/04M8JFQBTL?=
 =?us-ascii?Q?CdBJMin+n7foPshUDWPddQ99MSDA+gEhbpZ+aHXqF/+EAyjqeGgFYk5ve+r/?=
 =?us-ascii?Q?o38sC5jFcgrkr01uF8qg47C07nyvDTrvle+hAfbJG/Oai2Zy7lKqD4f1F0Gr?=
 =?us-ascii?Q?TJKMaCybJRL5c7fGj2PJsdWSi00Kkk0DDxY1+yBoIHONnL/EZfRcDeQaHt+U?=
 =?us-ascii?Q?K7jTjeA3wLXyxCix0smGLka29cAKdVsGZ5h6JhxOIaQtx9dFE4zrZdI4eh1n?=
 =?us-ascii?Q?NlcmLsnWkb585quWwl7DNtyqGUHfA25v0AU05FvmHzDxd1wtL09cOxSBJMVm?=
 =?us-ascii?Q?7wFONbX36EK+6Vi7YpHmLDY+z9VtnHOzNCa0+tMy/hMVUFjye3Zw4ivLmWz0?=
 =?us-ascii?Q?uL8z/X+BDDi5jZgXmt/RgWzx1WGEWtcxn9nF1wDLuniqIB70x7BoA6H9a/vY?=
 =?us-ascii?Q?WyXgSF6RpfQngN93QRueTPguuRMIwZQxRkAdzIWV9VMNDZeyIupfJ6/izVCz?=
 =?us-ascii?Q?JGqMTblF0af96P7Xxq4M81294ir9AUTZOFlWaM4UJQbYvJ3Au5hKbtegFg2d?=
 =?us-ascii?Q?AAPwsLBmDjEVQe/HAmHVWtVCy8WJ3AvWBkct3cdCO7S68RMJnxCBC3MDYyfC?=
 =?us-ascii?Q?+DE82dJAYH2lF77mLK61xuFtU4Bx3z9VGal7Ane9shAzreBsk+R54kyq1ViK?=
 =?us-ascii?Q?xgX06sRY4Nx5l2g20uM6VZS3093Qrok/dWmVizQcXYBMgOdfpLZc2qxOkh+T?=
 =?us-ascii?Q?3ZMbMO6xXaqN3/gOLc23RwpAeW9tOC48IjZpWMQEymnZD0a78uJ30XX+R8Z/?=
 =?us-ascii?Q?rFnzMx+YAlhE1nnGtlnpff4bs/o+Qayan2KgPQQnBntDBvvznruZR9pIHV6+?=
 =?us-ascii?Q?lGI1B9OJ/+FGTF4dcGP8uKLQgx2CkXK+mwS6V3PvY+81PP8JazDbMEr4sIF4?=
 =?us-ascii?Q?wHdlT9zprmaF7b5J8hb11/8Hld6aBuMnNdzymXGZUdx043guoUcIZKnw6FMy?=
 =?us-ascii?Q?XAElIXM472APUWWTtLPIOU0JP97jY6Z5gAdn+pGeVGci?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR18MB4666.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 077f57f1-b252-4601-f41c-08db422c6456
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 05:51:03.1917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nJU97CVksn1r5cYnCSYGhVml4QbmIhjcng+uE7FXFTh9BfMdw/Hs0NbU4nmrS79aJFaMMn2wu37mOgRcHH+zrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1397
X-Proofpoint-GUID: G-JkuObHE43MGmuXTFcdJHJ6t0DSqmui
X-Proofpoint-ORIG-GUID: G-JkuObHE43MGmuXTFcdJHJ6t0DSqmui
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_17,2023-04-20_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Emeel Hakim <ehakim@nvidia.com> <ehakim@nvidia.com>
>Sent: Wednesday, April 19, 2023 7:51 PM
>To: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
>edumazet@google.com; sd@queasysnail.net
>Cc: netdev@vger.kernel.org; leon@kernel.org; Emeel Hakim
><ehakim@nvidia.com>
>Subject: [PATCH net-next v7 1/5] vlan: Add MACsec offload operations for
>VLAN interface
>
>Add support for MACsec offload operations for VLAN driver to allow
>offloading MACsec when VLAN's real device supports Macsec offload by
>forwarding the offload request to it.
>
>Signed-off-by: Emeel Hakim <ehakim@nvidia.com>

Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
