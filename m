Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D260D1F9D1C
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 18:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731021AbgFOQV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 12:21:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42066 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730842AbgFOQVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 12:21:23 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05FG3s1e117865;
        Mon, 15 Jun 2020 12:21:15 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31mua6c66f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 12:21:15 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05FGKmCF024406;
        Mon, 15 Jun 2020 16:21:14 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 31mpe8y3rs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 16:21:14 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05FGLD6738470132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jun 2020 16:21:13 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44FD1112061;
        Mon, 15 Jun 2020 16:21:13 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2B8B112066;
        Mon, 15 Jun 2020 16:21:12 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 15 Jun 2020 16:21:12 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 15 Jun 2020 09:21:12 -0700
From:   dwilder <dwilder@us.ibm.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        wilder@us.ibm.com, mkubecek@suse.com,
        netfilter-devel-owner@vger.kernel.org
In-Reply-To: <20200615114412.GD16460@breakpoint.cc>
References: <20200603212516.22414-1-dwilder@us.ibm.com>
 <20200603220502.GD28263@breakpoint.cc>
 <72692f32471b5d2eeef9514bb2c9ba51@linux.vnet.ibm.com>
 <20200604103815.GE28263@breakpoint.cc>
 <20200615114412.GD16460@breakpoint.cc>
Message-ID: <15bb6cfdb238c9c9ddb5135986aa532b@linux.vnet.ibm.com>
X-Sender: dwilder@us.ibm.com
User-Agent: Roundcube Webmail/1.0.1
X-TM-AS-GCONF: 00
Subject: RE: [(RFC) PATCH ] NULL pointer dereference on rmmod iptable_mangle.
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-15_03:2020-06-15,2020-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=785 bulkscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1011 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 cotscore=-2147483648 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006150111
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-15 04:44, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
>> dwilder <dwilder@us.ibm.com> wrote:
>> > > Since the netns core already does an unconditional synchronize_rcu after
>> > > the pre_exit hooks this would avoid the problem as well.
>> >
>> > Something like this?  (un-tested)
>> 
>> Yes.
>> 
>> > diff --git a/net/ipv4/netfilter/iptable_mangle.c
>> > b/net/ipv4/netfilter/iptable_mangle.c
>> > index bb9266ea3785..0d448e4d5213 100644
>> > --- a/net/ipv4/netfilter/iptable_mangle.c
>> > +++ b/net/ipv4/netfilter/iptable_mangle.c
>> > @@ -100,15 +100,26 @@ static int __net_init iptable_mangle_table_init(struct
>> > net *net)
>> >         return ret;
>> >  }
>> >
>> > +static void __net_exit iptable_mangle_net_pre_exit(struct net *net)
>> > +{
>> > +       struct xt_table *table = net->ipv4.iptable_mangle;
>> > +
>> > +       if (mangle_ops)
>> > +               nf_unregister_net_hooks(net, mangle_ops,
>> > +                       hweight32(table->valid_hooks));
>> > +}
>> 
>> You probably need if (table) here, not mangle_ops.
>> I'm not sure if it makes sense to add a new
>> 
>> xt_unregister_table_hook() helper, I guess one would have to try
>> and see if that reduces copy&paste programming or not.
>> 
>> >  static void __net_exit iptable_mangle_net_exit(struct net *net)
>> >  {
>> >         if (!net->ipv4.iptable_mangle)
>> >                 return;
>> > -       ipt_unregister_table(net, net->ipv4.iptable_mangle, mangle_ops);
>> > +       ipt_unregister_table(net, net->ipv4.iptable_mangle, NULL);
>> 
>> I guess the 3rd arg could be removed from the helper.
>> 
>> But yes, this looks like what I had in mind.
> 
> Will there be a followup?  Otherwise I will place this on my todo-list.
> 
> Thanks.

Hi Florian

I am working on a patch.  Will post soon.  Sorry for the delay.
