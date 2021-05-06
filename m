Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E03737519E
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 11:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhEFJjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 05:39:12 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55024 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhEFJjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 05:39:10 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1469Nm4e144761;
        Thu, 6 May 2021 09:37:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=DfoZg/EJyv1J1Ur8oyCVj6Lob9E6npm7TWUpZvwlkdQ=;
 b=lotbw+IA/+4rSHD6IZu2S4D7pxOWbwT5HIrrTNB02T/TZZUHfDkXVkYsM6MLg36ZfXQE
 c65iPl+ZEipn3RcxGlVmBy1rXRoHoo2OY0RM+/PfabyOnkGO0wi8FAuD2GkuHQy+kdIt
 wvel42TBu/TQVTwGujS0OjBZzjj7EPfdk4zzb+r9gTLfMF3F8/KnbWf/ptNp9Nu4dRh3
 Axzht2zd89DDNCtBkgAaAKUd/Df2Jr7vGYRe6KaZci5zEl1EKW7brh6b3VAhv37F818+
 W60rurQ9boV9HG//P7UniPpeX9FJDBRkidSM/auSHoGDEgmF9RY4Xz7wsUthJlp+BiZo WA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38begjcc5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 May 2021 09:37:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1469PiuQ004949;
        Thu, 6 May 2021 09:37:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 38bewsgfkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 May 2021 09:37:44 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1469bhYi045611;
        Thu, 6 May 2021 09:37:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 38bewsgfkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 May 2021 09:37:43 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1469besP015292;
        Thu, 6 May 2021 09:37:40 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 May 2021 02:37:40 -0700
Date:   Thu, 6 May 2021 12:37:31 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, meijusan <meijusan@163.com>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, meijusan <meijusan@163.com>
Subject: Re: [PATCH] net/ipv4/ip_fragment:fix missing Flags reserved bit set
 in iphdr
Message-ID: <202105060033.tDmPYOCg-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505132557.197964-1-meijusan@163.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: Ko1rMzgzYzMquw8bURs27wahlO4y6lad
X-Proofpoint-ORIG-GUID: Ko1rMzgzYzMquw8bURs27wahlO4y6lad
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9975 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 malwarescore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2105060065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi meijusan,

url:    https://github.com/0day-ci/linux/commits/meijusan/net-ipv4-ip_fragment-fix-missing-Flags-reserved-bit-set-in-iphdr/20210505-212826
base:   https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git master
config: i386-randconfig-m021-20210505 (attached as .config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
net/ipv4/ip_output.c:655 ip_fraglist_prepare() error: uninitialized symbol 'ip_evil'.

vim +/ip_evil +655 net/ipv4/ip_output.c

c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  631  void ip_fraglist_prepare(struct sk_buff *skb, struct ip_fraglist_iter *iter)
c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  632  {
c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  633  	unsigned int hlen = iter->hlen;
c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  634  	struct iphdr *iph = iter->iph;
c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  635  	struct sk_buff *frag;
c6cde148fcd3bf meijusan          2021-05-05  636  	bool ip_evil;
c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  637  
c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  638  	frag = iter->frag;
c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  639  	frag->ip_summed = CHECKSUM_NONE;
c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  640  	skb_reset_transport_header(frag);
c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  641  	__skb_push(frag, hlen);
c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  642  	skb_reset_network_header(frag);
c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  643  	memcpy(skb_network_header(frag), iph, hlen);
c6cde148fcd3bf meijusan          2021-05-05  644  	if (ntohs(iph->frag_off) & IP_EVIL)
c6cde148fcd3bf meijusan          2021-05-05  645  		ip_evil = true;

"ip_evil" is never set to false.

c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  646  	iter->iph = ip_hdr(frag);
c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  647  	iph = iter->iph;
c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  648  	iph->tot_len = htons(frag->len);
c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  649  	ip_copy_metadata(frag, skb);
c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  650  	iter->offset += skb->len - hlen;
c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  651  	iph->frag_off = htons(iter->offset >> 3);
c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  652  	if (frag->next)
c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  653  		iph->frag_off |= htons(IP_MF);
c6cde148fcd3bf meijusan          2021-05-05  654  
c6cde148fcd3bf meijusan          2021-05-05 @655  	if (ip_evil)
c6cde148fcd3bf meijusan          2021-05-05  656  		iph->frag_off |= htons(IP_EVIL);
c6cde148fcd3bf meijusan          2021-05-05  657  
c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  658  	/* Ready, complete checksum */
c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  659  	ip_send_check(iph);
c8b17be0b7a45d Pablo Neira Ayuso 2019-05-29  660  }

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

