Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 217F11A4276
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 08:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgDJGT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 02:19:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52436 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725816AbgDJGT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 02:19:27 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03A6GM4w019182;
        Thu, 9 Apr 2020 23:19:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=SZbD226Kr6z2I3OgJjTospeTy3gv4D510pEmAhelI2E=;
 b=emwg0zT911CGkLk14egebac91YXrlbIxkHP2G+BAVktrjHjgKUCU76PieRJP7QoevgIQ
 yOp2ZgvAoLSep2uuNQClhUI3gs0txRJhJIIWT0ehJl+Lhv3hw7o+enBp4YmTEVN2qFSj
 Jozc4TGEnMd6ripeZpixeYPxQ7m+CnGEaYw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3091n45y91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 09 Apr 2020 23:19:16 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 9 Apr 2020 23:19:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJFAzNFVxPhGP5B9fHpGY0rVE6dk5W2/QKRhxzEzDk1n3yX9ZqQlm18Bfrdw/tBsCx5D+jiyE9iFkIKiHTYK14QMJ5P44BDK0FwyP2+on1XKINsLeiLmHgBCZWAbb6IstYPE803B8sNh1/JVR8HnTbBoq1WYnWh5Kmw4RQtaAgBkzpJjrPpGvq1MBtNIDRCldviGKE+bqI258DzdkNRlbjIgDvvKUI8R31hwtgxV4lLm8MOqujNSj8/OvrCz2WRedjEcTstcNeAfCg+ChyIzAowiNwe/XV1tmS3RZgKZ/D3O/mrAv0moS4ULNKVaQOKgHu+IDcXslhCWiBwuZe4qxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZbD226Kr6z2I3OgJjTospeTy3gv4D510pEmAhelI2E=;
 b=UUzaoeHfnmOgsE5mGlqVI+6KbMgHVxpLfpTkjc5nZgZFMw8wD0IoYiUNXNTbo5WtNq6vITCOqJRST1lJETcROWx1ZhjoDvp8RUKrJdqoSmrX+E6ttF+3pLp3CCKRyDQWodKee/Zt8et4D7yO4CXiJNRusP9k6gfVPl+TCKvq9nGjHkcxNbiPIbNo6sjPkggdAnUZcTF4IjR/uNTEoWkZVzXIJO6cLBeZ7sVtfmixBXu9ttz9RsxDtVP8f5l3oreSFVwm2+Lv2/Gh3XkoVLuovVxmZftqicgW8m8iq5D4USkcggG/XPuOw7AoWmgez7PrNdtLi/qIEhxtxsY7Tcknyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZbD226Kr6z2I3OgJjTospeTy3gv4D510pEmAhelI2E=;
 b=TmDmN7APQnfiIoU4f0FE6Nr+DaUvFh/Z61RglqsXGoSVf8t/XZKgvavFAbe/WzDnNLwT0ymztSs6/edXtVwRRuCmnNNp1IDegpC4TsfaainYDceMosHMeFAcUy731jcdov/WKVJOVib+/MOfKfCm7UPBEaf5oK2ovEO9hHzbc2Q=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB4075.namprd15.prod.outlook.com (2603:10b6:303:4d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Fri, 10 Apr
 2020 06:19:13 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2878.018; Fri, 10 Apr 2020
 06:19:13 +0000
Subject: Re: [RFC PATCH bpf-next 08/16] bpf: add task and task/file targets
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232529.2676060-1-yhs@fb.com>
 <20200410032223.esp46oxtpegextxn@ast-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d40f0a39-093f-2ed2-d5d0-b97947f0093f@fb.com>
Date:   Thu, 9 Apr 2020 23:19:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200410032223.esp46oxtpegextxn@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR14CA0032.namprd14.prod.outlook.com
 (2603:10b6:300:12b::18) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from rutu-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:75b7) by MWHPR14CA0032.namprd14.prod.outlook.com (2603:10b6:300:12b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 06:19:12 +0000
X-Originating-IP: [2620:10d:c090:400::5:75b7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 392177eb-71f7-4f10-b725-08d7dd171693
X-MS-TrafficTypeDiagnostic: MW3PR15MB4075:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB407514766555081C9D6D81F7D3DE0@MW3PR15MB4075.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(136003)(396003)(366004)(39860400002)(346002)(376002)(16526019)(31696002)(4326008)(86362001)(6512007)(478600001)(186003)(31686004)(6486002)(2906002)(66946007)(316002)(66476007)(66556008)(53546011)(6506007)(52116002)(2616005)(8676002)(81156014)(5660300002)(6916009)(54906003)(36756003)(8936002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JWxTkXqQk6o+0sRvi29l7nXVYc4p2oYSJ73DqjoDUKu2VIxEDEtc4tgGvJng/jROOxF8OrhLUbf1G+nPojjEnb8IaDiUbR4eXkIOXbKy9NFxOjJI1ZCVxawUw2HXARWY386ZNHEEY5iGkmVbeEfFlFVfVICGGZedGZ2AZcL33Y0k2dBcj60haZi1kbIWefN3C8Dd983OMz/VKj+D0eNlrp1OnF1yEBzZVEBdOlZ00NTKIDxw8WS8DIv+37mzFDpQ+UQCuuxpTZOs/W39olH25qHQyoHrf2jCaj4XBnbxf2lYQDzgEc+0RKtiWgM/sET7Dwy/+3uck7LzL34zoPWP1Qt7JX3odikX3kxXbmTbeDptnIiQpIJAyrLqSbQlWglKkbVpi1Dzyefhn6gn/rQ48ySwhsk72SPtoMJ5JnC87oCH1I7PnB7Mhqqf4aXUZs58
X-MS-Exchange-AntiSpam-MessageData: t3z1KhGNU0iVMp1xT7gHdHVw5LBEH9WZECLonvX79407okMLVk1aZS+2Hv5Ogdr61cp7NoOYKvoYDse3SdhBIKHwlsDqPQ3If9uLnd3lKSmesFgQpsFmN2BlV7i315OLzOZvFKJCbBYLcwgO0QD1fExZjkOlowApzHxif9NAmmTg9WWaT4I0PB2dU07LcGPD
X-MS-Exchange-CrossTenant-Network-Message-Id: 392177eb-71f7-4f10-b725-08d7dd171693
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 06:19:13.1290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D+9qy86ThV2Rl8rUxns5f9rsj7Jj4NGHJKAtx1/atPRflavuy+FCqO0QPFNj0Q9z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4075
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-10_01:2020-04-07,2020-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 clxscore=1015 mlxlogscore=763
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100053
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/9/20 8:22 PM, Alexei Starovoitov wrote:
> On Wed, Apr 08, 2020 at 04:25:29PM -0700, Yonghong Song wrote:
>> +
>> +	spin_lock(&files->file_lock);
>> +	for (; sfd < files_fdtable(files)->max_fds; sfd++) {
>> +		struct file *f;
>> +
>> +		f = fcheck_files(files, sfd);
>> +		if (!f)
>> +			continue;
>> +
>> +		*fd = sfd;
>> +		get_file(f);
>> +		spin_unlock(&files->file_lock);
>> +		return f;
>> +	}
>> +
>> +	/* the current task is done, go to the next task */
>> +	spin_unlock(&files->file_lock);
>> +	put_files_struct(files);
> 
> I think spin_lock is unnecessary.
> It's similarly unnecessary in bpf_task_fd_query().
> Take a look at proc_readfd_common() in fs/proc/fd.c.
> It only needs rcu_read_lock() to iterate fd array.

I see. I was looking at function seq_show() at fs/proc/fd.c,

...
                 spin_lock(&files->file_lock);
                 file = fcheck_files(files, fd);
                 if (file) {
                         struct fdtable *fdt = files_fdtable(files);

                         f_flags = file->f_flags;
                         if (close_on_exec(fd, fdt))
                                 f_flags |= O_CLOEXEC;

                         get_file(file);
                         ret = 0;
                 }
                 spin_unlock(&files->file_lock);
                 put_files_struct(files);
...

I guess here spin_lock is needed due to close_on_exec().

Will use rcu_read_lock() mechanism then.
