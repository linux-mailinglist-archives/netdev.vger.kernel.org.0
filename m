Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4184981D1
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 15:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbiAXOO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 09:14:27 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46428 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231544AbiAXOOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 09:14:25 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20OE2Gnm005517;
        Mon, 24 Jan 2022 14:14:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=gVFWa6OgKWFss0OLW1DtkoEOUMeJIgnPDLHIO8QBMwA=;
 b=Mc8G0NRAzC1Xt3qZZkYw82FRmZw+KacTY6f9i4HdgSuvfrvoUItClJh9w7/2k3q1FZ/K
 wmcc67G6bgHarJLi6T+ajO/BLPP766/8C1sLmvLsgrlDtzqi/DY8lvdwX1xCFFF75rch
 U4WUXQU9TiHv3UhbqQqX9kucsyHbW14YtwJjhxn/g+k1s8IjMB5FzDVCettYje2NM8Rr
 CTy8fCnZYEEsyGknkZwbCNCdjwlnxhozP7vYfZQGv38rvY1F0wJSINt4fdWU5ZnGVqvJ
 JF13B/eP1q/lBmCdCmxw6Cq25psc6NqiJhn6Efy52PRSpLx6hx7dxR+ndiU35+xDnNhp +g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dswh9g13j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jan 2022 14:14:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20OECtPS079289;
        Mon, 24 Jan 2022 14:14:07 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by userp3030.oracle.com with ESMTP id 3dr71vhq47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jan 2022 14:14:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WigBq9DbFo9OgiAZmY+TfM+YlkjVJqO2zyknRQ/WpKDqBNAhBHF8bp1JF+5oscKhSVQhwWHuPc4TYKcc9ydHMt98dksWvJnAFUAnctmmevtQrPfqwjGU6kwq0iB2McLGBqbIepKAgfIJOfbejq49LcX2zCV4wFSs43SHQqCDzHvM0zLTvEBJi1Q2LaHJfWvnZ8un5zBsOWowSAhLrpZ8TqMOi9nzfw92zfbiRaYayq8RTEA9SCVQ+I6zfevxEPavwo/5HDG3/x9zkrxsl98yP5d4pL1Ep0YQ3kO5DMPP9noUy2B1ZAqU9S0Dfqougdt7qC7LLwOqim0OEnR3GuUChQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gVFWa6OgKWFss0OLW1DtkoEOUMeJIgnPDLHIO8QBMwA=;
 b=VYNRz5t5OjW+Fvn9Uk7j0F2RM0PJCROf1krEcZlT2s/qjLv+dlKum7ca5s4MLQtfuWdGC4E+bz+amIKwQcauRLk/rdLM0XcGM4FlmfRrtvbYmwOVeEomED/bEygQ6GuyLuZfXJ6p66WocQXgR4ogSJYtSsjCVxEKOJjtln/ZxzKjnb4KARZ/ywVHED/UrfF0DHOmHMVWflP/ctm6jssqNd+ke+wlsWGXskLYo8umDXE1Ww8g9UUF3v8Ep2Ggg56/fsgavCJbD8oGe1ZDfHxiGYVX2L4yxwFxLB6DK+CaJuY36pqJgB3nSvjh+PfgV5CkaOEFHKfTVEUFDVUH2EWmIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gVFWa6OgKWFss0OLW1DtkoEOUMeJIgnPDLHIO8QBMwA=;
 b=FC2em7yPx2g5+OI0mRIXrVn56aW3RL1PC0BCDXEy6/UMswrIBQFXMGldC3A7gZ6HxqrmtNvXmTGoSdxwEGp4EgL7LqwIZebR6+6WJk2geQO7cD3qI86HQklkVEBs2+fpxg8DrSigXlsWyN5EYgt9+ilKyU4bpsdHPtYfMiIhsrI=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BLAPR10MB4836.namprd10.prod.outlook.com (2603:10b6:208:326::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Mon, 24 Jan
 2022 14:14:05 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6%4]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 14:14:05 +0000
Date:   Mon, 24 Jan 2022 14:13:51 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [RFC bpf-next 0/3] libbpf: name-based u[ret]probe attach
In-Reply-To: <CAEf4Bza8m33juRRXa1ozg44txMALr4A_QOJYp5Nw70HiWRryfA@mail.gmail.com>
Message-ID: <alpine.LRH.2.23.451.2201241348550.28129@localhost>
References: <1642678950-19584-1-git-send-email-alan.maguire@oracle.com> <CAADnVQJMsVw_oD7BWoMhG7hNdqLcFFzTwSAhnJLCh0vEBMHZbQ@mail.gmail.com> <CAEf4Bza8m33juRRXa1ozg44txMALr4A_QOJYp5Nw70HiWRryfA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
X-ClientProxiedBy: LO4P123CA0383.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::10) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5204571-3b2b-4f5f-f786-08d9df43c751
X-MS-TrafficTypeDiagnostic: BLAPR10MB4836:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB48363FEEBC2966E33619042BEF5E9@BLAPR10MB4836.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6n+dGvIj5NcvHXlu6ZzNsrdNmfCPiop/5etY4/qyBfhWMa5Yuu9Y0wSG5Q5jewloZF5xrt+u/9c9VMcBvuw6lyMf+pknCIY9H5+lzDox4KJ079uDZ2q+xwHO2c8x7F3Jo5Mjgkm3uVbRKJRdVyRgI9M+cEjKtBGbLWaZBUhg4wE28eeOBvfeZTl2MZ3ZOxfWVKHs74ONbUlVFGXViF1vVUmY5A4HL1kzM14RxAY0DuF7OtPDTF19k8F8zDM/JG6RXyka5QK1y72qvrdRYIhCB+e8gYMWnimKPmlajCifofjutvIwmWwwxQ9249jQ0J5kLW0yIaMv4uGzBuhcyND/QRUbnZVmD6zliaec+KPXxpcBb5X5ybEM04ehwjq/TcwTQFKjwcD/E0NG/0zwi5JeNibc/X85ejKXFDD8KPYLTPYnmAnjYy2RNRxZghrNjdqP48b4iVKHbFeMaGDyPENDRyNSixZQz7eLRUD2eD/itRM8nFfFhtZinVSTaSU8n81/FT8gIPHUSoGCWk6+HUxum6RVBC0gbpXzXQFbuNb8kzwrPQF4/O0WdSBLBk6ErCLu4GjcDIrjZmC0JywnvLf0Jg6yWN6PVwpzKtaIkjeK5BHYHbsbC9dC7QgUjaMvzD0O1zhSIMnUSNQUEvhNjieD1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(8936002)(8676002)(66946007)(54906003)(44832011)(66556008)(66476007)(7416002)(6916009)(6486002)(316002)(6666004)(2906002)(6512007)(9686003)(86362001)(38100700002)(33716001)(53546011)(6506007)(83380400001)(5660300002)(186003)(508600001)(4326008)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Deu6RpKF8XF+7FqVOtX65kX8D4R4qytjIw/Pk/lez+2ZECeB9rz28vCnlw8M?=
 =?us-ascii?Q?tNh90NaGxx5Qm9E7aLxKdX8fH6EhjhEDwYDx0o2JGqKMV6P2fTnnQrWwUzks?=
 =?us-ascii?Q?k1XeNNVl9PGuwJyTconxiIWobpCUnok6zBdKbIJHKKi4dW1PmLCw5YW+qt1f?=
 =?us-ascii?Q?/44ZLyK2miglurZiOIfcpUndvllUJc0god8PFU5y2W67Z8oNrmXB5c6fw6IW?=
 =?us-ascii?Q?/4V/bfQirq7U3yztiVZ6kqXP5A+jZV9UHzV3cq4hjtZnb4RWNwOtgsz62jEO?=
 =?us-ascii?Q?0l3bNRhe/kdaQlYQkF68lxnPgfLDS+DqdWMNKcqfsYFARjlTshT2vqDQ7bUn?=
 =?us-ascii?Q?4oBkUOnbAYLvpKcs25X1DHJhnlCMD0tisFXmdZS/8ISCxHtyJCDg1mCxRfKj?=
 =?us-ascii?Q?Wo4CzWmRP2IauRJXI8Y2HmkULcGinwFRAGZtT3xhjSppF1lW0hgG6KVrjCF6?=
 =?us-ascii?Q?GuZKB412Y1R+7BH4aWZYyieXongBVDCyDNS+X3LN4vaw1dZDQ2eiVjkqom2l?=
 =?us-ascii?Q?/kWAYW2yKUtz3UCVodI74RBr/3zos54CWA9GCIi+ovqic8YdbxVgrP5q5kPv?=
 =?us-ascii?Q?KicSD7ys3KDzwKtuJWlk6rPM6kefjE/+qGtPu7c8/YAod133yQDBQJZYYULJ?=
 =?us-ascii?Q?RcumdIX5m2PFmqnhrZ4Ta1Zftk708/RV7te40NVeIb6Qt0ImdQY44MxLpT5A?=
 =?us-ascii?Q?S/hGwKA6MJkrDk4bOLuqKdX7dKm0toooWGsH1cU1syssZ8DLLrSexMu4xt0M?=
 =?us-ascii?Q?C1Wvjm+mf9C/u0TsC4FfVgwlCxb86sRUISmqGsqh+TY3It+IYlEz6uweLYIx?=
 =?us-ascii?Q?Tk7Q6EtdmBQEnjnZ1nmD7B0yu15EaAuiGLax85y7bJbMLevoBbInfpRfkfHg?=
 =?us-ascii?Q?C8kNaMmi+72YlHCgmg0HFGTs/6pNpQP+BX2iBs2+giKJr3N8B7+Uq7MgGUAT?=
 =?us-ascii?Q?+pH4WJqgTfA0FXC46HtTI9ocUMqHVa+DmCWGFkeDZbp9Tl5zjKc4FuiBhiiW?=
 =?us-ascii?Q?jO3q15t6r5gnk+6gz4Ag2NbGBsuKREB434t8UYjCLkeEQuQrONQ8HyhQ/BrD?=
 =?us-ascii?Q?1nHgzyqEcRM27YSH+bMkjOTdoi4nn0d9ajjGNzqZ2a9JmdUaKNGqY3NEgQnC?=
 =?us-ascii?Q?ggBy/IHV3RAEEV5nMZ0mvURBrG8GI2Wyo5xT4riSBh47+G5L+CdROEnZCFfU?=
 =?us-ascii?Q?AskSicjql0W3pnOtmgGEg74qOzex/c50p/uWtprIFus5jqLTu8WhkMIMGVrF?=
 =?us-ascii?Q?JH0nUKlT5lNcYJent+DvTvb/UCtyWf4LWAYxkbR//+oIVaPop0aahBYZK6Ua?=
 =?us-ascii?Q?C1nY2oq/OJ8yYECHrgkDgPHeNB8mPRR+cAxXhlH2pJzA31ZE7KQ54Yotb8CK?=
 =?us-ascii?Q?GGdg03kufveFM9sunmxPvpYOeI3iKNYmax2Qg22NJ5MmAzmEfsmH+5k52Ffi?=
 =?us-ascii?Q?W4AL8rb/5L3UMSwUHogDiBcmLauPmBw2x6E61p/jrsZBhAT4nkUu7u2tkSgC?=
 =?us-ascii?Q?GpxaKxaA/j7s40/5LyI/zjNf8Qow+jygdFXNJF2bD7+bKkVF9PEAyQ/TIeuV?=
 =?us-ascii?Q?6cc70CymqnGIx3LFBr6dRui5lOmSgXFeLafnqmGSB4KAP6ILWPfehRluQTLP?=
 =?us-ascii?Q?0BWt4F/sUFh6xlcI4LUcFGrhD4Up6/1WoMv/T9VYneCLAyD40cZVcUnLo4VC?=
 =?us-ascii?Q?3FUOqw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5204571-3b2b-4f5f-f786-08d9df43c751
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 14:14:05.1038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2TrdnOwMRqxgs7jhhUvJO5TCOs62TkR6WH1vVEZapid6V1jO8iYeIrq4CzYIMoXDA2qihTl731mtmbCh/DG5Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4836
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10236 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201240095
X-Proofpoint-ORIG-GUID: PhozDHMME7o-gRQ4uVOmG86H8jICyov6
X-Proofpoint-GUID: PhozDHMME7o-gRQ4uVOmG86H8jICyov6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Jan 2022, Andrii Nakryiko wrote:

> On Thu, Jan 20, 2022 at 5:44 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Jan 20, 2022 at 3:43 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> > >
> > > This patch series is a refinement of the RFC patchset [1], focusing
> > > on support for attach by name for uprobes and uretprobes.  Still
> > > marked RFC as there are unresolved questions.
> > >
> > > Currently attach for such probes is done by determining the offset
> > > manually, so the aim is to try and mimic the simplicity of kprobe
> > > attach, making use of uprobe opts to specify a name string.
> > >
> > > uprobe attach is done by specifying a binary path, a pid (where
> > > 0 means "this process" and -1 means "all processes") and an
> > > offset.  Here a 'func_name' option is added to 'struct uprobe_opts'
> > > and that name is searched for in symbol tables.  If the binary
> > > is a program, relative offset calcuation must be done to the
> > > symbol address as described in [2].
> >
> > I think the pid discussion here and in the patches only causes
> > confusion. I think it's best to remove pid from the api.
> 
> It's already part of the uprobe API in libbpf
> (bpf_program__attach_uprobe), but nothing really changes there.
> API-wise Alan just added an optional func_name option. I think it
> makes sense overall.
> 
> For auto-attach it has to be all PIDs, of course.
> 

Makes sense.

> > uprobes are attached to an inode. They're not attached to a pid
> > or a process. Any existing process or future process started
> > from that inode (executable file) will have that uprobe triggering.
> > The kernel can do pid filtering through predicate mechanism,
> > but bpf uprobe doesn't do any filtering. iirc.

I _think_ there is filtering in uprobe_perf_func() - it calls
uprobe_perf_filter() prior to calling __uprobe_perf_func(), and
the latter runs the BPF program. Maybe I'm missing something here
though? However I think we need to give the user ways to minimize
the cost of breakpoint placement where possible. See below...

> > Similarly "attach to all processes" doesn't sound right either.
> > It's attached to all current and future processes.
> 

True, will fix for the next version.

I think for users it'd be good to clarify what the overheads are. If I 
want to see malloc()s in a particular process, say I specify the libc 
path along with the process ID I'm interested in.  This adds the
breakpoint to libc and will - as far as I understand it - trigger 
breakpoints system-wide which are then filtered out by uprobe perf handling
for the specific process specified.  That's pretty expensive 
performance-wise, so we should probably try and give users options to 
limit the cost in cases where they don't want to incur system-wide 
overheads. I've been investigating adding support for instrumenting shared 
library calls _within_ programs by placing the breakpoint on the procedure  
linking table call associated with the function.  As this is local to the  
program, it will only have an effect on malloc()s in that specific 
program.  So the next version will have a solution which allows us to 
trace malloc() in /usr/bin/foo as well as in libc. Thanks!

Alan 
