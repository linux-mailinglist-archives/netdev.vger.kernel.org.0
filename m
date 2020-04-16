Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177F51ABDEE
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 12:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504972AbgDPK3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 06:29:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50822 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504943AbgDPK2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 06:28:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03GASCrM163539;
        Thu, 16 Apr 2020 10:28:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=9GnHtY/DK7oYqI+ruPXthvzHvwuzbjixOeDMP1A3xwA=;
 b=ryIu0QaKo4LeO4bycJw+XOJ8VTN2Bit2GAL9x4zh0mW+wgPUUKYohMOjoeEJ7nFV8F+X
 UmHMEnkWRp5hi1SuX1ImTiIc6vODNq/tbZQ02lPH3y+tBHdzHL1LXdO5OF+lAAbYkApZ
 3VcOub2stRuofE2WSJkHG2UQRaG5sZFxINw5Mis5Yh1ZHdTCeZNjpTQdN65ogH1B2hpT
 ZnWmHK+zs0k82NcoNmZCuJm/g5G3r6cAXwv5Dsxiq9LLykNhgE2etZlCwPgVUOEy6kZy
 nwss6PZbtEDxw0mRCZ7o6AUYYjTGr38iuuCCW/i1l4ijk0R417piCZ++wNatgXaIriIc vA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30dn95rjtp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Apr 2020 10:28:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03GAHsZJ099521;
        Thu, 16 Apr 2020 10:26:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30dynya2y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Apr 2020 10:26:26 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03GAQOEY025630;
        Thu, 16 Apr 2020 10:26:24 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Apr 2020 03:26:24 -0700
Date:   Thu, 16 Apr 2020 13:26:12 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        syzbot <syzbot+8a5dadc5c0b1d7055945@syzkaller.appspotmail.com>,
        ast@kernel.org, bpf@vger.kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: WARNING in bpf_cgroup_link_release
Message-ID: <20200416102612.GO1163@kadam>
References: <000000000000500e6f05a34ecc01@google.com>
 <4ba5ee0c-ec81-8ce3-6681-465e34b98a93@iogearbox.net>
 <a9219326-c07c-1069-270c-4bef17ee7b88@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a9219326-c07c-1069-270c-4bef17ee7b88@fb.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9592 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=896 suspectscore=0
 malwarescore=0 phishscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004160071
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9592 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1011
 malwarescore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 phishscore=0 spamscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=965 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004160072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 09:51:40AM -0700, 'Andrii Nakryiko' via syzkaller-bugs wrote:
> On 4/15/20 4:57 AM, Daniel Borkmann wrote:
> > On 4/15/20 8:55 AM, syzbot wrote:
> > > Hello,
> > > 
> > > syzbot found the following crash on:
> > 
> > Andrii, ptal.
> > 
> > > HEAD commit:    1a323ea5 x86: get rid of 'errret' argument to
> > > __get_user_x..
> > > git tree:       bpf-next
> > > console output: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_log.txt-3Fx-3D148ccb57e00000&d=DwICaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=T2Ez0XmyIpHmEa_MPTTUOh61jMDXqwETtTaTbSe-2M4&s=-6XBbsNV1O4X5flrx4Yssfjc56d0qeSHgwHhd92UPJc&e=
> > > kernel config:  https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_.config-3Fx-3D8c1e98458335a7d1&d=DwICaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=T2Ez0XmyIpHmEa_MPTTUOh61jMDXqwETtTaTbSe-2M4&s=s5-1AlWtSiBvo66WN4_UXoXMGIGIqsoUCrmAnxNnfX0&e=
> > > dashboard link: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_bug-3Fextid-3D8a5dadc5c0b1d7055945&d=DwICaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=T2Ez0XmyIpHmEa_MPTTUOh61jMDXqwETtTaTbSe-2M4&s=hAA0702qJH5EwRwvG0RKmj8FwIRm1O8hvmoS7ne5Dls&e=
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > 
> > > Unfortunately, I don't have any reproducer for this crash yet.
> > > 
> > > IMPORTANT: if you fix the bug, please add the following tag to the
> > > commit:
> > > Reported-by: syzbot+8a5dadc5c0b1d7055945@syzkaller.appspotmail.com
> > > 
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 0 PID: 25081 at kernel/bpf/cgroup.c:796
> > > bpf_cgroup_link_release+0x260/0x3a0 kernel/bpf/cgroup.c:796
> 
> This warning is triggered due to __cgroup_bpf_detach returning an error. It
> can do it only in two cases: either attached item is not found, which from
> starting at code some moreI don't see how that can happen. The other reason
> - kmalloc() failing to allocate memory for new effective prog array.

If you look at the log file then this was allocation fault injection in
bpf_prog_array_alloc().

https://syzkaller.appspot.com/x/log.txt?x=148ccb57e00000

regards,
dan carpenter

