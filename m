Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900D84F1228
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 11:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354554AbiDDJi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 05:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354457AbiDDJiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 05:38:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAE933A23;
        Mon,  4 Apr 2022 02:36:29 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2348Vwt4002328;
        Mon, 4 Apr 2022 09:36:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=drsUIcFULe9n7Sfe1QPWOgdt7gO8SMNSV9muB6XXfRw=;
 b=URklWIlcbElfBS5G4d/zKt+BcjPBaOvKGnsE4AorIRCoh32HRijGkhFL7k7lVO0H/lyf
 MrPgbWseUBSG6BSoEWFHQuVlaBa+NC7OTCYiQeHqFV1QgYu+BpLuATPWEELL7SL4OZh0
 7Cy5cvWRLOz7RUs111wVQK5MF/brNtzAMDhIyIcCXrqzJ7lxXiELQ648kS/Ic5l9Rjlf
 PLbwTrVLTCFLWvkuptRlBNDqDzyccVxvz6PaSs1Vx0Wf8REDWguAINS1JRXHtvPvvS+W
 kpA8S0/XNoRAMbB5ABoqYuIA01v5hYurvBTczQhZ95zqa3Q5GXcz4avwqG9IkLUnJ9ph iQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f705gnfen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 09:36:09 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2349WTnF008508;
        Mon, 4 Apr 2022 09:36:08 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f705gnfdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 09:36:08 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2349X2V4005653;
        Mon, 4 Apr 2022 09:36:06 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3f6drhkarc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 09:36:06 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2349a4Qo46465394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 09:36:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CD41AE053;
        Mon,  4 Apr 2022 09:36:04 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B41EEAE045;
        Mon,  4 Apr 2022 09:36:03 +0000 (GMT)
Received: from [9.171.47.144] (unknown [9.171.47.144])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 09:36:03 +0000 (GMT)
Message-ID: <55ff4df690d18faa4c88d05009ebe6d0c70ad37d.camel@linux.ibm.com>
Subject: Re: [PATCH v5 bpf-next 3/5] libbpf: add auto-attach for uprobes
 based on section name
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Date:   Mon, 04 Apr 2022 11:36:03 +0200
In-Reply-To: <CAEf4BzZ5iLi=Xuw=+Ez30LWqPQuuVK8hGaVwfyHL5A+XDkFWgw@mail.gmail.com>
References: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com>
         <1648654000-21758-4-git-send-email-alan.maguire@oracle.com>
         <CAEf4BzbB3yeKdxqGewFs=BA+bXBNfhDf2Xh4XzBjrsSp_0khPQ@mail.gmail.com>
         <CAEf4BzZ5iLi=Xuw=+Ez30LWqPQuuVK8hGaVwfyHL5A+XDkFWgw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JzNm4q1il3M3oSuHCIfcJxCvuUBMcQib
X-Proofpoint-ORIG-GUID: 2dupiGv-FnBtIEOeOo7BYSVH4SDHXuuH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_03,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1011
 spamscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040053
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLACK autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-04-03 at 21:46 -0700, Andrii Nakryiko wrote:
> On Sun, Apr 3, 2022 at 6:14 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> > 
> > On Wed, Mar 30, 2022 at 8:27 AM Alan Maguire
> > <alan.maguire@oracle.com> wrote:
> > > 
> > > Now that u[ret]probes can use name-based specification, it makes
> > > sense to add support for auto-attach based on SEC() definition.
> > > The format proposed is
> > > 
> > >        
> > > SEC("u[ret]probe/binary:[raw_offset|[function_name[+offset]]")
> > > 
> > > For example, to trace malloc() in libc:
> > > 
> > >         SEC("uprobe/libc.so.6:malloc")
> > > 
> > > ...or to trace function foo2 in /usr/bin/foo:
> > > 
> > >         SEC("uprobe//usr/bin/foo:foo2")
> > > 
> > > Auto-attach is done for all tasks (pid -1).  prog can be an
> > > absolute
> > > path or simply a program/library name; in the latter case, we use
> > > PATH/LD_LIBRARY_PATH to resolve the full path, falling back to
> > > standard locations (/usr/bin:/usr/sbin or /usr/lib64:/usr/lib) if
> > > the file is not found via environment-variable specified
> > > locations.
> > > 
> > > Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> > > ---
> > >  tools/lib/bpf/libbpf.c | 74
> > > ++++++++++++++++++++++++++++++++++++++++++++++++--
> > >  1 file changed, 72 insertions(+), 2 deletions(-)
> > > 
> > 
> > [...]
> > 
> > > +static int attach_uprobe(const struct bpf_program *prog, long
> > > cookie, struct bpf_link **link)
> > > +{
> > > +       DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, opts);
> > > +       char *func, *probe_name, *func_end;
> > > +       char *func_name, binary_path[512];
> > > +       unsigned long long raw_offset;
> > > +       size_t offset = 0;
> > > +       int n;
> > > +
> > > +       *link = NULL;
> > > +
> > > +       opts.retprobe = str_has_pfx(prog->sec_name,
> > > "uretprobe/");
> > > +       if (opts.retprobe)
> > > +               probe_name = prog->sec_name +
> > > sizeof("uretprobe/") - 1;
> > > +       else
> > > +               probe_name = prog->sec_name + sizeof("uprobe/") -
> > > 1;
> > 
> > I think this will mishandle SEC("uretprobe"), let's fix this in a
> > follow up (and see a note about uretprobe selftests)
> 
> So I actually fixed it up a little bit to avoid test failure on s390x
> arch. But now it's a different problem, complaining about not being
> able to resolve libc.so.6. CC'ing Ilya, but I was wondering if it's
> better to use more generic "libc.so" instead of "libc.so.6"? Have you
> tried that?

I believe it's a Debian-specific issue (our s390x CI image is Debian).
libc is still called libc.so.6, but it's located in
/lib/s390x-linux-gnu.
This must also be an issue on Intel and other architectures.
I'll send a patch.
