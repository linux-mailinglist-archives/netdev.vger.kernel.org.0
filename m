Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6019B294432
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 23:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438622AbgJTVFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 17:05:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56056 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405157AbgJTVFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 17:05:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09KKwelY129658;
        Tue, 20 Oct 2020 21:04:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=LvLZjyTRAz3l/wge84OauKsfuvxiJRuPQJ3Dcv6dEhM=;
 b=zhIMdwysMMcUkksGNP+sTjjmX61Zdx8dhM0tErXZSj7W9d+A9OXiKsipm0rO+qSo4FD2
 iQkx/3ayDO6P0xqfaaLorl/xZyZ/r86Qhw+6xdJZNjKcnYDOof/gjmcfPjxxwJsnDODF
 bYW8XTwJdYcXbHNZkMljsgI5+KcK9DKCKFsvPy3Whiv1trU6u+u5Ka1eknKmQfbZZK+x
 fx6+2QnXhvvgtIKPiVicXCn4PS9EyWINgMLYHXBMo5nm6DSFZubWfP/RTGiG3/XK4mW/
 qC8k/W/7wckepjjScLzhI3NKUpHFPbZhznV/nrrbl6yYeFeUrSzAqxfUVEQI/QTdMKFy Jg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 349jrpnhaj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 20 Oct 2020 21:04:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09KKxsnw179837;
        Tue, 20 Oct 2020 21:04:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 348acr975y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Oct 2020 21:04:54 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09KL4rVx030833;
        Tue, 20 Oct 2020 21:04:53 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Oct 2020 14:04:53 -0700
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id C00136A00D6; Tue, 20 Oct 2020 17:06:34 -0400 (EDT)
Date:   Tue, 20 Oct 2020 17:06:34 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     eric.snowberg@oracle.com, john.haxby@oracle.com,
        todd.vierling@oracle.com
Cc:     Matthew Garrett <mjg59@google.com>, netdev@vger.kernel.org,
        Chun-Yi Lee <jlee@suse.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH RFC UEK5 2/7] bpf: Restrict bpf when kernel lockdown is
 in confidentiality mode
Message-ID: <20201020210634.GA21080@char.us.oracle.com>
References: <20201020210004.18977-1-konrad.wilk@oracle.com>
 <20201020210004.18977-3-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020210004.18977-3-konrad.wilk@oracle.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010200143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010200143
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 04:59:59PM -0400, Konrad Rzeszutek Wilk wrote:
> bpf_read() and bpf_read_str() could potentially be abused to (eg) allow
> private keys in kernel memory to be leaked. Disable them if the kernel
> has been locked down in confidentiality mode.
> 
> Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Signed-off-by: Matthew Garrett <mjg59@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> cc: netdev@vger.kernel.org
> cc: Chun-Yi Lee <jlee@suse.com>
> cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: James Morris <jmorris@namei.org>
> 
> [Backport notes:
>  The upstream version is using enums, and all that fancy code.
>  We are just retroffiting UEK5 a bit and just checking to
>  see if integrity mode has been enabled and if so then
>  allow it. If the default lockdown mode (confidentiality) is on
>  then we don't allow it.]

<sigh>

And that is what I get for _not_ doing --suppress-cc=all

My apologies for spamming you all!

<goes to hide in the corner of shame>
