Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C863143BE
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 00:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhBHX1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 18:27:37 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55190 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhBHX1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 18:27:31 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118NNhpG148767;
        Mon, 8 Feb 2021 23:26:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=w/G1lZRC+vgRBxfYDmrHCcTCTpOXCNl3eDr95g5hVP8=;
 b=XXAL7Yhywc5uSHCkuuhnsmks/LDMpHgvB1nmynox4lXYP9nY0yDomK9n3Scn4WnjjTa3
 YYFZxDp9qoPcRsHLk0KDQ5Ya8vzdsBtkSuVDWCHnsQRuvdjfaHZ0LyU0uM33NHdM+X63
 yEAE/3bS3vPtO+b0nxmsYtRmUewlQpK3ilGLshhik4JozNSR5kvHql9Cd9MrlBqpAvL4
 nEtvyltC5X1q8+FwNPq/mIxQbEPJvvfXiFyWDT+pG5PSnAscsmzC0AiuVb8+JlWG9pX/
 ipCSliVd5wVjlhsP1yLuGQ4xM5gm6WUANyVoOyu182etYqmk/tYMJoOrrxJ4Q+/XwEn5 Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36hkrmwpj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Feb 2021 23:26:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118NPKD1066341;
        Mon, 8 Feb 2021 23:26:37 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by aserp3020.oracle.com with ESMTP id 36j510ex88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Feb 2021 23:26:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O91ZEO3+jBJjxEmlv34UhNQnsSYxzzgiNn8PYN/On443kRm/mBw4uXyAoFgVs424kCPwWgouVy8r8FXxzHkRyNw40q/WKA4yWDsDgn7t7kPJpfPhnaAc/UnohhooS1C1AtmMI7IE5pc2LkQjygFxj0e8BiwmohfiO4RqaNTwqGOQdjb3foU43SSvBruxo+9VFTmAE3vEhsFlBehxZ4rNar/BlFXVYJ7vI2lBgn6T0UN3c9mOvJo6bRHFFubs9MA6N/4tEQvGKbErLSs4cJnUYRPN2O9SV3AJ1p596NrIZAugBp+SkVegr+mUUlW7NNLGFcyKfcb4g6TyDC/9cXsj8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/G1lZRC+vgRBxfYDmrHCcTCTpOXCNl3eDr95g5hVP8=;
 b=idFAWbekpVrX7pTLLdmtnfhFquaICohwnf00L5T8LktAhgOh7zgTDeY3OOMQ+vUhNNj/J95vrBQHkuhsfGHAutzJOJEHgx24PckLemoB6JQFE0vOe46pcXuuJx3qH8h2zaABqVr0kgVayJN3fpfTymHnxH9uh5s/KSfFPu0VmOlL2XzyFo11mjKQAexuVwejFwFfOobAjfGht1sTsudk0sfSpW9N3CLtd2V69+iWHE0e+/wj86plhb76/v/iOwaiWKUxgFTxXZVfF0CrBFHEITU5sP5rzBEADoL7dJv/h/dmKUXX4c7ak/teL1dFB2zxrEgmXbD4Mai+Bs2JV08xbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/G1lZRC+vgRBxfYDmrHCcTCTpOXCNl3eDr95g5hVP8=;
 b=isNbs91VY6kzo9J8SWRzi/sU3+JITTgEYQASB6GAvwmiD1AVVe9iFd3yJrCPDEUBdLLcz9Hkka9+JgOmVG4KiPVcJk31rew5XGbmEqN7NJPDrr1DoeP7SfvbpC6WwSTNgFqfLKUVUqPydN97Jk1m45VvVz5n9Eeb5wnNbzzEudA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3288.namprd10.prod.outlook.com (2603:10b6:a03:156::21)
 by SJ0PR10MB4414.namprd10.prod.outlook.com (2603:10b6:a03:2d0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Mon, 8 Feb
 2021 23:26:35 +0000
Received: from BYAPR10MB3288.namprd10.prod.outlook.com
 ([fe80::f489:4e25:63e0:c721]) by BYAPR10MB3288.namprd10.prod.outlook.com
 ([fe80::f489:4e25:63e0:c721%7]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 23:26:35 +0000
Subject: Re: [PATCH 4/7] xen/events: link interdomain events to associated
 xenbus device
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
        Jens Axboe <axboe@kernel.dk>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Stabellini <sstabellini@kernel.org>
References: <20210206104932.29064-1-jgross@suse.com>
 <20210206104932.29064-5-jgross@suse.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <b7576788-c734-1fd7-69fa-2a576541880e@oracle.com>
Date:   Mon, 8 Feb 2021 18:26:30 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <20210206104932.29064-5-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [138.3.200.35]
X-ClientProxiedBy: BYAPR08CA0022.namprd08.prod.outlook.com
 (2603:10b6:a03:100::35) To BYAPR10MB3288.namprd10.prod.outlook.com
 (2603:10b6:a03:156::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.74.101.99] (138.3.200.35) by BYAPR08CA0022.namprd08.prod.outlook.com (2603:10b6:a03:100::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Mon, 8 Feb 2021 23:26:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d72ed724-1cc4-4ba9-92d4-08d8cc88f9b6
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4414:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4414380B8C5BABD102D3B2C98A8F9@SJ0PR10MB4414.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +6/XoSpBFjuBOP9EWZ6K/1Z3YNC3l2zn8lxmOZ2/iEjfQzyVK0Qga4hoKZN3mFaKq7a5tiXe+Bgie5j0huS887JAMLLsqh4AgWKrTJEscHF7pfkxOgYDZv4pN45yP2ZUypXs5lEg1iFkk8Ph0Kc9VLajqOIixpunfmRgtblxMTnYyLGteJHD2Vz32Brl4gvRshPoywhAZVnEEtHssebM08b4HjSmimKl6lpAnNWWr6hrLqyBL5UGKjSYGYWi3pLIAjvGHjwTkyb6MZ7oTjrUVo7W+4eYqxiQ3aRoSObDWV27wLE5t03Z3MvLB3V46JumEFtHk9p0IVJBjDLQEvmZlyYhLydYvDLtx4ASC/qH3ZzgRYIglrcetdk4TqqyoqxWG1/bu1fMShe6WLpuDy8dM/srTXX5HCmNVODpnAQmuXZpwY6JWyagT6ZjOTpKRdzvtOqSJ6iG9HP261pQdrp4Ozx26huPgKyD+LmmAFcw6s5U+FN561xeVRIP4bcVwRbO3DLEfPQnSbJjwOuOhTSIv96qDA/JfOXxYddzpb3qhqe4l6+gV117OLuk+82wHQi8tkrtCE8Fsn/7P34JsEh5+xBekJvwguDRdkp6o4imivM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3288.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(39860400002)(346002)(366004)(136003)(44832011)(36756003)(4744005)(26005)(5660300002)(16526019)(66946007)(66476007)(66556008)(186003)(86362001)(478600001)(2906002)(8676002)(8936002)(2616005)(6486002)(31696002)(16576012)(54906003)(83380400001)(7416002)(956004)(53546011)(316002)(4326008)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TkZLRGg3MitMVnM0QlNhbmc4dkpuN0NReTBMYzNmVk5tTkx1LzFzMFVLWTl5?=
 =?utf-8?B?U0pGczYyRkl0R0RsbTFnWmNQY0EyTDRpd2JxeVYyb1Bhajh1VEwxQUNLYURX?=
 =?utf-8?B?YjYyZVBaT1ZzZnhTR1J0Qy9BclJDcFN4c2pkVWVNcVA0bUo4SE9senRCVENz?=
 =?utf-8?B?WVVaODhZTGdNRzk5WGVMUXZuWnlNNlJsZW5aN2tYR2hnSWsrNUlTNHJVL210?=
 =?utf-8?B?SFpaTEMwMnh1OG16UTlWR21FZ0JTR1I2OTNxZnhsYlJueC9DUk0wTXVCKzlD?=
 =?utf-8?B?bVVWTXRVY3JsTGdJUTVqVWsyc2x6TmExNHhzS3BVZjl4R3dlRVVDci8xeldB?=
 =?utf-8?B?Tk44UCttN3J5aXQ5R25vUFhpRExYWXZ0aWhyQnpjL1I5WlVGVWkrQm9ISGtL?=
 =?utf-8?B?cXdHUGV3YTl2Wk5WY0FRM2pSL1FZVEhWeDM5MU5odWdKZzRSbHFKVlI2VkxF?=
 =?utf-8?B?UVJvazYxa3hoY0VST2lodytaZ1VSTXBRMnZQREprcjBycmdpOEdPeDF0R29E?=
 =?utf-8?B?Z0Voa3ZIbCtwaWpoN3pTRFVhaytKekcyaXhReG1peU90bWtuTjNJOFNjdENJ?=
 =?utf-8?B?RG9XY2lxOXR4cktpRjdUQzF5SmtnSUNJblpkNkRtQTlPQ09GTm5DQkc4bFBW?=
 =?utf-8?B?WXlraFNBRWlRQVA1RHhZbEF1T3dZeWhnY2VzM3lxblJTNHJ6cXlnZnBVTDRX?=
 =?utf-8?B?MFUzTjd4NmJIMjhRYTZhRC85Sko1WGI4NWlzbktPY1JzRjc5bUxYdktVUW14?=
 =?utf-8?B?RnNoRlFwSjg2RmphM0tJamRYVEY4YVloTjEyMTVCTUMvMnUwaUNPdTZWNGdh?=
 =?utf-8?B?dHFlTDNtWHFuQWppdml0N2ZIVjBYaTBrTWM4QlhPNUZIVTAwYXRIcTdTTisy?=
 =?utf-8?B?ZGhUa1VvVi9jWUpTNHBmai9CQ1k1d2hoVGtkdVJtUUJmcVhCbHNQcVNYWnQy?=
 =?utf-8?B?aFZwL0U1aENUczZRT04vb3I4V2NzSTgrcExrVG1lWiszNmpaRGdwNG5VaTdM?=
 =?utf-8?B?VjFPWExTQ3d0VXVpZU4ydGYzZzlPK1VXTmNweGFtTHQ2NnFlSFJqMWVpWHJC?=
 =?utf-8?B?L3BiWmV5UEprK2FYZmpXUDdOSi9na001TTF3QnZUdlVFWmFkeE9wb2ZQbzl1?=
 =?utf-8?B?OTQyWU9EWld4MlAyYlBJZ000TlorVXNSbHJDQVFYVjNFY0pWWkhraFBBcVZI?=
 =?utf-8?B?eno2WjNVOE5NSnpmWXVUQTR5WitGOHF2bXdiUW9ZSUI1a1YvRDRwUlVzUUFo?=
 =?utf-8?B?Sk90UGVqL2QyMG93L1NGb1hjTGNOWlVZZzFBUVg4dWQ4UCtPVlBzRWxsSHVP?=
 =?utf-8?B?OUZKNVIrdnNVWW1XZUo5SXVsdVozaWk0UXIwODc2SS9MVGV1VFVkNm9kQU5h?=
 =?utf-8?B?NDlmeURzVWIrUVZjNmFaMkJoa3E4S3ZQN2k1TG9sNXlxSTJ4WUpkWEl3cXdx?=
 =?utf-8?B?SWpsRk55bXdTRFNLTklqQ2xwblE0YVlFbksxZnBIYnBIa0xFZmdVZUZHcVQ2?=
 =?utf-8?B?WlhtY2NaTDMyZCszNUt1RER3bVEvUy9JTkxiOXQ4OXh5SU5zVlhsVTlaMW4x?=
 =?utf-8?B?dS9BcVkzN05sQzZIM0kxajd4dUJhOXgreEFTdjJJTVZQekpJZkZ0LzdWNXor?=
 =?utf-8?B?eWdYbWREbjE1azVJbWxCK1YzS2d2Zkw5WUIyUTBNRFhXbWhTdWIya29kb3Za?=
 =?utf-8?B?ZzlEMzlESTNjYnJTRzJFd2NkTjVvQ3k2S1N0T0FXblZ3alF1MkdEVnhFOVE3?=
 =?utf-8?Q?Be3hNdoSwvekLXJjYCvcwYB6sUHCdOEk+qGAYXj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d72ed724-1cc4-4ba9-92d4-08d8cc88f9b6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3288.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 23:26:35.1504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XmGBa14TU8D+lZFERDqc744yX4ULKG/78vx4caTi4bbH6bien1aadzusp9BRFCp8Aagrdi2dq8woWCLPMLZf/hvbytaeGgqyFNdls7PjJYU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4414
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102080130
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102080130
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/6/21 5:49 AM, Juergen Gross wrote:
> In order to support the possibility of per-device event channel
> settings (e.g. lateeoi spurious event thresholds) add a xenbus device
> pointer to struct irq_info() and modify the related event channel
> binding interfaces to take the pointer to the xenbus device as a
> parameter instead of the domain id of the other side.
>
> While at it remove the stale prototype of bind_evtchn_to_irq_lateeoi().
>
> Signed-off-by: Juergen Gross <jgross@suse.com>


Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

