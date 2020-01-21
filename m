Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCE40143C1A
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 12:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbgAULfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 06:35:52 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53506 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgAULfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 06:35:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LBXNBK034296;
        Tue, 21 Jan 2020 11:35:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=O5LftPvaGtM67EfFxPIbJZyTLJGrdDk4vCyyoTH8rgs=;
 b=H2m6sw8gKZMIJjcwFJ8L4Up2uDvY1FZUjbYrLIzoo0QE3/WrQMP4QRK3pQJzrz8mD5GB
 Ralso39tSUuxT/sTVrTBISgrKdlhwh5oNQAUc0UgGyrKjRejK1+lDK8909OPMvNYRkm7
 W1TSUq20A9ubTEMRgNeKNN640QJ4GIF18YeoLeoS9XiAenPd+pVGbPcpOzFfC/62sdsR
 Vtr+9MYuCv7Q7k5qkBsssPz4xhjhl5lU0fYLmxbxvDb6jSyQNdW413HWNBKVuXv+QV3+
 rijTEHWbninGWsAJfZVRNKfp35Z3DS67crc09zTUZTSjL2Jq84B9zILkfrUh2Mpp3WrS XA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xkseucgkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 11:35:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LBY2BF182316;
        Tue, 21 Jan 2020 11:35:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xnsj4drrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 11:35:26 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00LBWk3f024105;
        Tue, 21 Jan 2020 11:32:46 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 03:32:45 -0800
Date:   Tue, 21 Jan 2020 14:32:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     syzbot <syzbot+29125d208b3dae9a7019@syzkaller.appspotmail.com>,
        pablo@netfilter.org
Cc:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in __nf_tables_abort
Message-ID: <20200121113235.GA1847@kadam>
References: <000000000000367175059c90b6bf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000367175059c90b6bf@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=758
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210098
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=820 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210098
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I think I see the problem, but I'm not sure how you want to fix it...

net/netfilter/nf_tables_api.c
   942  static int nf_tables_newtable(struct net *net, struct sock *nlsk,
   943                                struct sk_buff *skb, const struct nlmsghdr *nlh,
   944                                const struct nlattr * const nla[],
   945                                struct netlink_ext_ack *extack)
   946  {
   947          const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
   948          u8 genmask = nft_genmask_next(net);
   949          int family = nfmsg->nfgen_family;
   950          const struct nlattr *attr;
   951          struct nft_table *table;
   952          u32 flags = 0;
   953          struct nft_ctx ctx;
   954          int err;
   955  
   956          lockdep_assert_held(&net->nft.commit_mutex);
   957          attr = nla[NFTA_TABLE_NAME];
   958          table = nft_table_lookup(net, attr, family, genmask);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This is looking up table in net->nft.tables

   959          if (IS_ERR(table)) {
   960                  if (PTR_ERR(table) != -ENOENT)
   961                          return PTR_ERR(table);
   962          } else {
   963                  if (nlh->nlmsg_flags & NLM_F_EXCL) {
   964                          NL_SET_BAD_ATTR(extack, attr);
   965                          return -EEXIST;
   966                  }
   967                  if (nlh->nlmsg_flags & NLM_F_REPLACE)
   968                          return -EOPNOTSUPP;
   969  
   970                  nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
   971                  return nf_tables_updtable(&ctx);
                               ^^^^^^^^^^^^^^^^^^^^^^^
Then it adds it to &ctx->net->nft.commit_list

   972          }
   973  
   974          if (nla[NFTA_TABLE_FLAGS]) {
   975                  flags = ntohl(nla_get_be32(nla[NFTA_TABLE_FLAGS]));
   976                  if (flags & ~NFT_TABLE_F_DORMANT)
   977                          return -EINVAL;
   978          }
   979  
   980          err = -ENOMEM;
   981          table = kzalloc(sizeof(*table), GFP_KERNEL);
   982          if (table == NULL)
   983                  goto err_kzalloc;
   984  
   985          table->name = nla_strdup(attr, GFP_KERNEL);
   986          if (table->name == NULL)
   987                  goto err_strdup;
   988  
   989          err = rhltable_init(&table->chains_ht, &nft_chain_ht_params);
   990          if (err)
   991                  goto err_chain_ht;
   992  
   993          INIT_LIST_HEAD(&table->chains);
   994          INIT_LIST_HEAD(&table->sets);
   995          INIT_LIST_HEAD(&table->objects);
   996          INIT_LIST_HEAD(&table->flowtables);
   997          table->family = family;
   998          table->flags = flags;
   999          table->handle = ++table_handle;
  1000  
  1001          nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
  1002          err = nft_trans_table_add(&ctx, NFT_MSG_NEWTABLE);
                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Added to ctx->net->nft.commit_list

  1003          if (err < 0)
  1004                  goto err_trans;
  1005  
  1006          list_add_tail_rcu(&table->list, &net->nft.tables);
                                                ^^^^^^^^^^^^^^^^
Added to net->nft.tables

  1007          return 0;
  1008  err_trans:
  1009          rhltable_destroy(&table->chains_ht);
  1010  err_chain_ht:
  1011          kfree(table->name);
  1012  err_strdup:
  1013          kfree(table);

net/netfilter/nf_tables_api.c
  6995  static void nf_tables_commit_release(struct net *net)
  6996  {
  6997          struct nft_trans *trans;
  6998  
  6999          /* all side effects have to be made visible.
  7000           * For example, if a chain named 'foo' has been deleted, a
  7001           * new transaction must not find it anymore.
  7002           *
  7003           * Memory reclaim happens asynchronously from work queue
  7004           * to prevent expensive synchronize_rcu() in commit phase.
  7005           */
  7006          if (list_empty(&net->nft.commit_list)) {
  7007                  mutex_unlock(&net->nft.commit_mutex);
  7008                  return;
  7009          }
  7010  
  7011          trans = list_last_entry(&net->nft.commit_list,
  7012                                  struct nft_trans, list);
  7013          get_net(trans->ctx.net);
  7014          WARN_ON_ONCE(trans->put_net);
  7015  
  7016          trans->put_net = true;
  7017          spin_lock(&nf_tables_destroy_list_lock);
  7018          list_splice_tail_init(&net->nft.commit_list, &nf_tables_destroy_list);
                                       ^^^^^^^^^^^^^^^^^^^^^  ^^^^^^^^^^^^^^^^^^^^^^
This starts the process of freeing everything from net->nft.commit_list,
but we need to delete it from the net->nft.tables list as well.

  7019          spin_unlock(&nf_tables_destroy_list_lock);
  7020  
  7021          mutex_unlock(&net->nft.commit_mutex);
  7022  
  7023          schedule_work(&trans_destroy_work);
  7024  }

regards,
dan carpenter
