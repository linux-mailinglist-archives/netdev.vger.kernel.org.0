Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35AF1C8287
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 08:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgEGG3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 02:29:42 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55330 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725783AbgEGG3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 02:29:41 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0476Rabp026215;
        Wed, 6 May 2020 23:29:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=K7yehJBG2O2v4RHXG/X4n1PY0QxGAAd3lYUp68TAsoM=;
 b=F+xePUGY3N5twMgv4iI+s2CruidQcE45dVWNgbAEXyvAqm/rt4lAO4AxFkcSB1kSlZ8Q
 ZHC2YKWpiwIEoKP1jk6lQdrzcrLZq76uZo4WyqRSHHLBPnlfChDrA99MIQp79gFTpzIO
 34SKDJd6VCn09ONRxY5LjCXLkm/0tcOuBsM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 30ufak8bjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 06 May 2020 23:29:25 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 23:29:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TgG/Qnp/8+FvWPF83JJRWdjMMfvhqPgPsHfqmxNF5E4MSfe5EZCuMgbnfkE+sdfvbE0oeqQWlktlslRN9ToVhrtXxgHlzVFJ30rMH0Q0uCp+F/rs4XvJiLf6VDWrGwt7SqT9W/yexZbVg1dmuBI32axYwp0KqiuA+V/xpP+tlInipIQR/OcwIHqtsRpO+uWu5SsInT7N+0/oFELUIkqRYElRoXacdf/qCAHkZrw/Z5i26S/MXLd4SRZOIaOh5oZSuifUfdfq0A/558EmTNGsBTD/GcmD+q4QEegjezpNF0ZGL6vIMezlyEYHKMN7hEa02d4DxE5E2laufJFJvYbHvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7yehJBG2O2v4RHXG/X4n1PY0QxGAAd3lYUp68TAsoM=;
 b=Iqj3yJN/hYhYZ7MvWlAxtajdNbv/6Pbw20EQtrzYlkl66jzpIJf3tce2jsdX2aVd9Q7Dwv6JOM21VQ1r5+T3BvL2h/AMf4m49ldzk2YgtClAbb3i3ffoqT/mL2III8ctBS5Ac/CJlO+U2diz7ARJBNFO4ybh5DX8ZspyTpAZ0EYMk/Bdl6Oi2IsimRXNqZPJEXEmxIHYLZ3E9WnP+TPQkqzbGL7E+iMT2nYovmnAiwbPR5DE3ubNYyqqJxnJdQP3jFHUEJMju3i+FxyQ2QegGS6AxMLx4/3rQdCr4Ln8zaEH5OiegPylQ6KXelzyw7S3IoNTTS0V+vUdwTFHHaZEEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7yehJBG2O2v4RHXG/X4n1PY0QxGAAd3lYUp68TAsoM=;
 b=GjDRtYxXiHWDbHg+x8cUnHksLafeoP4VK1yfX6u76wXUFrczdIsB2OxwSEdgttcSYH6u3OJYpe1DX5wJzQDzeuWXWullZ8Mm2mmJxbtlf6/0UsZOdL718MY6NjePX9ad0roJY+3EjfeuY7rAae0mi1a1d2KlkMDLRij6orfLUjQ=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3753.namprd15.prod.outlook.com (2603:10b6:303:50::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 7 May
 2020 06:29:23 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.030; Thu, 7 May 2020
 06:29:23 +0000
Date:   Wed, 6 May 2020 23:29:21 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next v3 5/5] bpf: allow any port in bpf_bind helper
Message-ID: <20200507062921.iah2c4cfxtxlqm5p@kafai-mbp>
References: <20200506223210.93595-1-sdf@google.com>
 <20200506223210.93595-6-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506223210.93595-6-sdf@google.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR08CA0016.namprd08.prod.outlook.com
 (2603:10b6:a03:100::29) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:bdb8) by BYAPR08CA0016.namprd08.prod.outlook.com (2603:10b6:a03:100::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Thu, 7 May 2020 06:29:22 +0000
X-Originating-IP: [2620:10d:c090:400::5:bdb8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76b3472b-a1af-45b4-d994-08d7f24ffb5d
X-MS-TrafficTypeDiagnostic: MW3PR15MB3753:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3753DD9DBE2F64BEC928CF05D5A50@MW3PR15MB3753.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03965EFC76
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h62kJqiW6YeDqr20wO/JbBkfCDxhoImBB/QYalh7PjrXqg90deQ7cK8gbUvS6ceGP1LQmBw0i0peUTs1PIubAAfLfSIIYs+5gdBp3zxUbJOQnJ3I+8QGR3ek6+/JRvJZtc0O2F2NPZfRNDG4U/1BwoPm/GBMsdK4ISImWXJmGG6QiK6KBSvMVJjFDURtsQIku9pUM2sx6qcKaCiDh75e4rOZQ8ZdQyn1PM9mwDwho3lMlrtFt/g/uCkEM34pp2DDCkDn4uX/Cm9DA+9cw2sfoorR8ardKTPI7BMUvrXtZUBk1Tv4qgoQWm9DZRn+wnUbrsVEzlIZcgrC/ihoiBk5f3/sCMpLKphO4L7JDZNjXwGF6ZvZupjdhm7wZOTUw4oFMsaxHgrJAPvGdWIMaboe8O0y83d6fwZKNVMffKJf4PAmC2gRDpRjKz/t+Vxw9RGBEokMsoYgTz2X5YOk+9V4Bt+YeC63zZiJKyvALV87+8XsWsp5CC7wvHcTln7/Juvup6Yp91fu2kqy3OijD84Rcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(376002)(346002)(136003)(366004)(396003)(33430700001)(8936002)(1076003)(33440700001)(86362001)(66556008)(66946007)(55016002)(83280400001)(83300400001)(5660300002)(83310400001)(83290400001)(83320400001)(66476007)(8676002)(2906002)(9686003)(478600001)(52116002)(186003)(6496006)(16526019)(4326008)(316002)(6916009)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: s7zJiM4DRyu3X2ZOpFIhWlNVd6eTXMpBmbY3uwlrls+rXIPUmQHdSnZZjyYKUAgG7aIzwilfWF2oZ9irKNxvtRSYz2lw6Bnc2vtAqwIqcIkE+jtQ/76Q4QBvixf/T6St6qkODnRtsQlWMwlRvvc43FtCdcMlhjxVVSDX7Kd9pSSRJJdSzp+i2RqWQNHyUOo/TcSblh4EFPm+eksp6UKBk99x/W/hWW6CBor3gNhPYHaIHuC5x4xNBGv8Es3e+F0dzbIYJVP1A4vM0/UXSXMEsc1onEbat9AamEU+jTqKPKTb3wkADqAY49WRP9HxTnHeBGirfeg7H0CiEoUNjG8Tvb9niM+x22GdvUEDOY/lKPoj0wMqn5XvpvvP2YAmi1+YPmrh8QOjffqT/YdfaPgnqIfd1kgesyClyPSKW2/rRWpdP9R/rIfqGySsUJeyIoZ254zaYcFSLPDU5+qJjYn3r63nTY1fdi0obVklxZiIPyn9H3gkfNxfu2iheQyKzgcK5wWBoFg1F7XIANH+wt7FtUj3O5wq6Kb7tdgmf6iUkjTHgBweYjiURNzFgrKMnPeciV3SAB8tfzTjiFsvPObK7R/IR09P8XC/wTDsVpVpww81twlDX3zgXTv8ereEpNMvfP5G73H8WwTYtF+oaLUBCpWJKFDe44KdtV3QYbqRZ7CSVf61Cw7xs+zhIqlshN00Ile2drkPmTBHOWiDxUzMm+PVRd16x+UsAWosyi8xbI2hBUdg14lX8k5n4TRPLXtO1ocvntR0NfC6o6p/0ydPAOohc0lDnG8cyNYOHDYi9i3d+Tbbx4Vjwj9sVRhzAik20kUqUtKypVIQJGgL0nCP6g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 76b3472b-a1af-45b4-d994-08d7f24ffb5d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2020 06:29:23.1735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kF+uhVF7ugpC4lBjxxUAwsWt5Kik9z87PGkXIxVaU/2Qwj2owGEx7lXxefFdksJB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3753
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_03:2020-05-05,2020-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=827 phishscore=0 adultscore=0 impostorscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 03:32:10PM -0700, Stanislav Fomichev wrote:
> We want to have a tighter control on what ports we bind to in
> the BPF_CGROUP_INET{4,6}_CONNECT hooks even if it means
> connect() becomes slightly more expensive. The expensive part
> comes from the fact that we now need to call inet_csk_get_port()
> that verifies that the port is not used and allocates an entry
> in the hash table for it.
> 
> Since we can't rely on "snum || !bind_address_no_port" to prevent
> us from calling POST_BIND hook anymore, let's add another bind flag
> to indicate that the call site is BPF program.
> 
> v3:
> * More bpf_bind documentation refinements (Martin KaFai Lau)
> * Add UDP tests as well (Martin KaFai Lau)
> * Don't start the thread, just do socket+bind+listen (Martin KaFai Lau)
> 
> v2:
> * Update documentation (Andrey Ignatov)
> * Pass BIND_FORCE_ADDRESS_NO_PORT conditionally (Andrey Ignatov)
> 
> Cc: Andrey Ignatov <rdna@fb.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
