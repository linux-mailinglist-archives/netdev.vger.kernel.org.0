Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD2331BE60
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 17:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhBOQHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 11:07:52 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57964 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbhBOQDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 11:03:22 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11FFosU5138187;
        Mon, 15 Feb 2021 16:02:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=yuu9y0vBDIx5Rfd3xpQBWr5+YQLWRrMIfxbDN5bldpo=;
 b=eqhd30Fq8Wwz8nuJ9aYTRTIoIViXxdznsDHVimsswdcXDWhYLIQQSflZKnAIMhp7KYGU
 5gjE8bGoKdccbDLE+QwU0f8HTs69e/Grb7VJxw8euIhBxo+H9gHibbnBVB/o7BUM7c43
 /506W83m1BC1zsKdLUvBQRqU+E1aHONu/VSXbwnSd0tsLYYso6HYnZ1CnWuhvZRm06v5
 jMwUOWX+aCiAqvf74SCTd/rUhA3blOdf7XeHJlU8c0F1fcoDuDT/xxGTWcCMgYksXtRC
 x3wG56uTyNCj1q5FOLUlP/zTxiktdvnlv/AJJN3F1j7+M2vcFV/ygmuGfJ7wO1x2MfRQ mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36p49b4max-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Feb 2021 16:02:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11FFpRef063347;
        Mon, 15 Feb 2021 16:02:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 36prhqhctd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Feb 2021 16:02:32 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 11FG2VDP008121;
        Mon, 15 Feb 2021 16:02:31 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Feb 2021 08:02:30 -0800
Date:   Mon, 15 Feb 2021 19:02:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     kbuild@lists.01.org, Arjun Roy <arjunroy.kdev@gmail.com>,
        davem@davemloft.net, netdev@vger.kernel.org, lkp@intel.com,
        kbuild-all@lists.01.org, arjunroy@google.com, edumazet@google.com,
        soheil@google.com, Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next] tcp: Sanitize CMSG flags and reserved args in
 tcp_zerocopy_receive.
Message-ID: <20210215160222.GE2222@kadam>
References: <20210215120345.GE2087@kadam>
 <33d68f94-2d20-fdc4-c572-16138aa6305b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33d68f94-2d20-fdc4-c572-16138aa6305b@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9896 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102150125
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9896 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102150125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 08:04:11AM -0700, David Ahern wrote:
> On 2/15/21 5:03 AM, Dan Carpenter wrote:
> > Hi Arjun,
> > 
> > url:    https://github.com/0day-ci/linux/commits/Arjun-Roy/tcp-Sanitize-CMSG-flags-and-reserved-args-in-tcp_zerocopy_receive/20210212-052537 
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git  e4b62cf7559f2ef9a022de235e5a09a8d7ded520
> > config: x86_64-randconfig-m001-20210209 (attached as .config)
> > compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> > 
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > smatch warnings:
> > net/ipv4/tcp.c:4158 do_tcp_getsockopt() warn: check for integer overflow 'len'
> > 
> > vim +/len +4158 net/ipv4/tcp.c
> > 
> > 3fdadf7d27e3fb Dmitry Mishin            2006-03-20  3896  static int do_tcp_getsockopt(struct sock *sk, int level,
> > 3fdadf7d27e3fb Dmitry Mishin            2006-03-20  3897  		int optname, char __user *optval, int __user *optlen)
> > ^1da177e4c3f41 Linus Torvalds           2005-04-16  3898  {
> > 295f7324ff8d9e Arnaldo Carvalho de Melo 2005-08-09  3899  	struct inet_connection_sock *icsk = inet_csk(sk);
> > ^1da177e4c3f41 Linus Torvalds           2005-04-16  3900  	struct tcp_sock *tp = tcp_sk(sk);
> > 6fa251663069e0 Nikolay Borisov          2016-02-03  3901  	struct net *net = sock_net(sk);
> > ^1da177e4c3f41 Linus Torvalds           2005-04-16  3902  	int val, len;
> > 
> > "len" is int.
> > 
> > [ snip ]
> > 05255b823a6173 Eric Dumazet             2018-04-27  4146  #ifdef CONFIG_MMU
> > 05255b823a6173 Eric Dumazet             2018-04-27  4147  	case TCP_ZEROCOPY_RECEIVE: {
> > 7eeba1706eba6d Arjun Roy                2021-01-20  4148  		struct scm_timestamping_internal tss;
> > e0fecb289ad3fd Arjun Roy                2020-12-10  4149  		struct tcp_zerocopy_receive zc = {};
> > 05255b823a6173 Eric Dumazet             2018-04-27  4150  		int err;
> > 05255b823a6173 Eric Dumazet             2018-04-27  4151  
> > 05255b823a6173 Eric Dumazet             2018-04-27  4152  		if (get_user(len, optlen))
> > 05255b823a6173 Eric Dumazet             2018-04-27  4153  			return -EFAULT;
> > c8856c05145490 Arjun Roy                2020-02-14  4154  		if (len < offsetofend(struct tcp_zerocopy_receive, length))
> > 05255b823a6173 Eric Dumazet             2018-04-27  4155  			return -EINVAL;
> > 
> > 
> > The problem is that negative values of "len" are type promoted to high
> > positive values.  So the fix is to write this as:
> > 
> > 	if (len < 0 || len < offsetofend(struct tcp_zerocopy_receive, length))
> > 		return -EINVAL;
> > 
> > 110912bdf28392 Arjun Roy                2021-02-11  4156  		if (unlikely(len > sizeof(zc))) {
> > 110912bdf28392 Arjun Roy                2021-02-11  4157  			err = check_zeroed_user(optval + sizeof(zc),
> > 110912bdf28392 Arjun Roy                2021-02-11 @4158  						len - sizeof(zc));
> >                                                                                                         ^^^^^^^^^^^^^^^^
> > Potentially "len - a negative value".
> > 
> > 
> 
> get_user(len, optlen) is called multiple times in that function. len < 0
> was checked after the first one at the top.
> 

What you're describing is a "Double Fetch" bug, where the attack is we
get some data from the user, and we verify it, then we get it from the
user a second time and trust it.  The problem is that the user modifies
it between the first and second get_user() call so it ends up being a
security vulnerability.

But I'm glad you pointed out the first get_user() because it has an
ancient, harmless pre git bug in it.

net/ipv4/tcp.c
  3888  static int do_tcp_getsockopt(struct sock *sk, int level,
  3889                  int optname, char __user *optval, int __user *optlen)
  3890  {
  3891          struct inet_connection_sock *icsk = inet_csk(sk);
  3892          struct tcp_sock *tp = tcp_sk(sk);
  3893          struct net *net = sock_net(sk);
  3894          int val, len;
  3895  
  3896          if (get_user(len, optlen))
  3897                  return -EFAULT;
  3898  
  3899          len = min_t(unsigned int, len, sizeof(int));
  3900  
  3901          if (len < 0)
                    ^^^^^^^
This is impossible.  "len" has to be in the 0-4 range because of the
min_t() assignment.  It's harmless though and the condition should just
be removed.

  3902                  return -EINVAL;
  3903  
  3904          switch (optname) {
  3905          case TCP_MAXSEG:

Anyway, I will create a new Smatch warning for this situation.

> Also, maybe I am missing something here, but offsetofend can not return
> a negative value, so this checks catches len < 0 as well:
> 
> 	if (len < offsetofend(struct tcp_zerocopy_receive, length))
> 		return -EINVAL;
> 

offsetofend is (unsigned long)12.  If we compare a negative integer with
(unsigned long)12 then negative number is type promoted to a high
positive value.

	if (-1 < (usigned long)12)
		printf("dan is wrong\n");

regards,
dan carpenter


