Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147C7248AAC
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 17:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgHRPyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 11:54:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23708 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728375AbgHRPy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 11:54:26 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IFkFpJ018173;
        Tue, 18 Aug 2020 08:54:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=2Fab4hxPMUOa5OxSRSvZjtvSixEB78HMYkCgmwxjoiY=;
 b=rpxkN2TP2v7Poo4CQMzWbZ9F9E6ZCZE0TWjOnbMDYmUNtYAI29pHGXgu+ODcrTypAgyb
 O+4vU+oiL3RfHFRD+a3tCFtWumbrtbCeOBqEBLo/gAGC+7hoftqBOS7nVH2eKkBFqG6L
 LFDkmHeZG2wVQSjXIt7TXX78nwyEIliqhco= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304paudre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Aug 2020 08:54:09 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 08:54:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WE5ANHjSi7Y0oTN5dMUyuSFMrddyhgjP4cuugBC7EarmrPwAo52SqrlNO18VYZjYUWoHNFeXjKiDsBE5/xeYAltZY4L4jfXr4xwri3VIi4NZZFeCk4xnMmPNqQh+inktxZaGi3Z4CX0rrI15MNPi392FJncfbnPhsiDWnMT3SXWHyGAF6at9iB8ooY9qL2XlLf6WDU5xI8ivYhkXcictQVeoBTfYDZHcled6/f/6qh9WXCi8E3TE4aL52EV1YPimi6slBhOgxbsLIyUqfXSlusjEalVkBJEHSIaMoqOR+wtNOAVxBag0W9JOT6V/Un+DBJOhCqpdHodaprJdzGivyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Fab4hxPMUOa5OxSRSvZjtvSixEB78HMYkCgmwxjoiY=;
 b=l8sDey+I9pffDjbO72eS9HB68MEQae6De3O/KUPk7CJYft/0d2DUSUKbgtD3hbkFOpfnYZuVEv0pLjFvsXnp8T/G44MRDG0bo4/S5mIKe36Vq/A7pA88I5g13FuiBFTzBJdqpTM1vLkZCvZGZ1lYcmmEOoXSTFod98ZNK9XbiXUZqNKVe8IxkmPnnGWi6MzdtxIQcJseKwR2GhawtcBt0h+TX89zEBo0kHnHmYHB0ShAvjt59eIj+llyhLrdfsDQDh1rpLTba2IIW1289kT6bLh8fAw8ktNDeH9AQGzD65v49TbOEaqoL4P+BF96KBxgY+DUErWswqjX8+6xnvSJ8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Fab4hxPMUOa5OxSRSvZjtvSixEB78HMYkCgmwxjoiY=;
 b=U0mtuz45eX0jjHZ4UEklPQXiuRZvLSU72YtVU+QnWPveQWNy3yywcaxjilYNJdQvCShh6q+zuRGOOH0HwJl9ivT7TpenGOyjXIHJs08sbtvrCj7GnrmcRA+iG7Vpg6uJ4hj+64PJL/492KDoRFor2s+EPeMUtXprr7Ml4iYOmp4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2951.namprd15.prod.outlook.com (2603:10b6:a03:f7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.22; Tue, 18 Aug
 2020 15:54:08 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Tue, 18 Aug 2020
 15:54:08 +0000
Subject: Re: [PATCH] libbpf: convert comma to semicolon
To:     Xu Wang <vulab@iscas.ac.cn>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kafai@fb.com>, <songliubraving@fb.com>,
        <andriin@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
References: <20200818071611.21923-1-vulab@iscas.ac.cn>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <92e4b6ad-89a2-626e-d899-7d0e35f37ba5@fb.com>
Date:   Tue, 18 Aug 2020 08:54:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200818071611.21923-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR12CA0008.namprd12.prod.outlook.com
 (2603:10b6:208:a8::21) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:a06c) by MN2PR12CA0008.namprd12.prod.outlook.com (2603:10b6:208:a8::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16 via Frontend Transport; Tue, 18 Aug 2020 15:54:05 +0000
X-Originating-IP: [2620:10d:c091:480::1:a06c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14920f9c-ab6d-4a7a-6293-08d8438ef0c8
X-MS-TrafficTypeDiagnostic: BYAPR15MB2951:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB29511A069D4C2AB6FFFB8B28D35C0@BYAPR15MB2951.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:147;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AT+jRuhRzjvvCzjxrbLBCYkl9fc3iD7BzKTjt+TCpewjPAuZxAQfl55t8okzEEEGo+KqmM1Rl6GIElz1TSibGgNap4GLTKGOwWw/hkMZ2NgHhh1EUXjCLNWhNUt0dvEpIYKqN8o4W1pm8Uhl3NLNaHEPIn0cvkQP8qbsC00XwT1BS20cmuADdmup2lde69mMDL2YBF/eRyAje9xt8FcJqlJOIG9umscJ3bXD7EFon1XvjRFb2Roa1xGnswBVzWYk1KzEGM6OmbRUiXesg2doFsZ6kdnuWh1ehAvy3dntBkf039prga274wUzXxlzZJfheKv9OMFoRNNYb1cy8wkMgjLuPaZp0ntgmWDhv+APLzcXWZsMjtmwx8Zq7CuThan0f0h5Drq39Zzg9KayR7FdWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(346002)(376002)(366004)(186003)(31696002)(2906002)(478600001)(66476007)(52116002)(66946007)(53546011)(31686004)(6486002)(36756003)(2616005)(16526019)(66556008)(86362001)(316002)(4326008)(5660300002)(8936002)(558084003)(8676002)(921003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: w+NW1tl77vCZYAPhD80wJF0OdDIAKJP7ZKHVIpLJlDiavpYdv7/O1QfgrAdEfNuLziN8stX2pjvQXQVKy/W2x7+TyfL3/jaXpRHb7mx8CdjP58zTLOJUqUFZqRx3+KhMraFXP1u07LZyW0j/7xCnQxyQ7pGp66YDs1+1oS63r5PBWa7rwXhjeWj6K/Bc6VBnAe1wk+aMHhQbzFNQA/LzoF1YkkFizDyccqDRp+p6QOhbFGY/DUefsPMe2eNJEoB+FT+6UpwTCu9Gu49CADNW258SRGPIUQPHWtkr1WJkIhr8LCButjFnR20HGW9vsXryS2sGCs2W1/dy0HfQ0sYAcj6uQWJfeHDxRn10sJURSAy3Kw+kAjTw0ZKb8uDlBSwhFZ64oaBnBw6SYkQ6jPtsCsYydboGdKZpFBxBG2XJTJ0IlFDoLuv2GekvZSB1B0NiJRpO/G+2Sp1tmQBMk9gp1NF9jgdeQZCzYzeGhjmp1BcwrO8XvrYTY9Zg5MGcoPRWt0Y3s/kH5D09k3knQsGdKRv9RY9xYIL9nngYOa744d0r+ClvckssUUPt/5n2V3g+jYh/ofUuCrJZqrpAOrHDp7djF4wISQV3z/wko/6yQKbsmBA1FyMm0HOVjzElyMSilfNedT3fyl4vG5yvNrsC2ceMAXxwwG2z+oeQBJbtspg=
X-MS-Exchange-CrossTenant-Network-Message-Id: 14920f9c-ab6d-4a7a-6293-08d8438ef0c8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2020 15:54:07.9205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sVh/jw8aeZ74RRgKHgqmoHv60jD9J+fbGtx1/3ZSYnmjKbdpy3f00ch7rCLS+9Rb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2951
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_10:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 suspectscore=18 clxscore=1015
 mlxlogscore=922 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180113
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/20 12:16 AM, Xu Wang wrote:
> Replace a comma between expression statements by a semicolon.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>

Acked-by: Yonghong Song <yhs@fb.com>
