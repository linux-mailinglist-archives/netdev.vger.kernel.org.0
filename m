Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57CB3166B3
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 13:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhBJMbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 07:31:01 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33584 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbhBJM2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 07:28:54 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ACPTsd125196;
        Wed, 10 Feb 2021 12:28:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=V/QQKYhssb1c/ULhEm/h6VOFSy7PGCdB3QzOc3CmcDM=;
 b=Mm2AbRMfuoTWym75vifiQSy9RG7chLOeEhwfWbtMt8BB6hGztxg4UP1fpQVlv/ayC7lM
 dTLD3SEtixhz1I5EJ1mVJgjQUyVzLNavZXXEf+QTJlFVR51srgX5bxKSW/mNvKqIyDXH
 OaTAvLkbWZzeMayb9HSp8fvDudCJapnqRUp3+zmNxYP30uBAM5kU245NzujqFBWwXxQd
 /13GFkkSURCYkLuygU8xdBZY7huHVIqUcnDNu/bPGokUdpRhXSeax/bP+rLJR1/OjU0L
 zZKG4JqTjtJmhXOSt+3qxsyKU7evzbqehsWoQNdLHByPS72/l1/gPH3w++94iKIJM1GJ VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36m4upsphe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 12:28:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ACQgb7111385;
        Wed, 10 Feb 2021 12:28:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 36j4vsr99h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 12:28:09 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 11ACS82Y030916;
        Wed, 10 Feb 2021 12:28:08 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Feb 2021 04:28:07 -0800
Date:   Wed, 10 Feb 2021 15:28:01 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     vladbu@nvidia.com, linux-rdma@vger.kernel.org,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [bug report] net/mlx5e: E-Switch, Maintain vhca_id to vport_num
 mapping
Message-ID: <20210210122801.GW20820@kadam>
References: <YCOep5XDMt5IM/PV@mwanda>
 <20210210114820.GA741034@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210114820.GA741034@unreal>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100121
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100121
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 01:48:20PM +0200, Leon Romanovsky wrote:
> On Wed, Feb 10, 2021 at 11:51:51AM +0300, Dan Carpenter wrote:
> > Hello Vlad Buslov,
> >
> > The patch 84ae9c1f29c0: "net/mlx5e: E-Switch, Maintain vhca_id to
> > vport_num mapping" from Sep 23, 2020, leads to the following static
> > checker warning:
> >
> > 	drivers/net/ethernet/mellanox/mlx5/core/vport.c:1170 mlx5_vport_get_other_func_cap()
> > 	warn: odd binop '0x0 & 0x1'
> >
> > drivers/net/ethernet/mellanox/mlx5/core/vport.c
> >   1168  int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out)
> >   1169  {
> >   1170          u16 opmod = (MLX5_CAP_GENERAL << 1) | (HCA_CAP_OPMOD_GET_MAX & 0x01);
> >
> > HCA_CAP_OPMOD_GET_MAX is zero.  The 0x01 is a magical number.
> >
> >   1171          u8 in[MLX5_ST_SZ_BYTES(query_hca_cap_in)] = {};
> >   1172
> >   1173          MLX5_SET(query_hca_cap_in, in, opcode, MLX5_CMD_OP_QUERY_HCA_CAP);
> >   1174          MLX5_SET(query_hca_cap_in, in, op_mod, opmod);
> >   1175          MLX5_SET(query_hca_cap_in, in, function_id, function_id);
> >   1176          MLX5_SET(query_hca_cap_in, in, other_function, true);
> >   1177          return mlx5_cmd_exec_inout(dev, query_hca_cap, in, out);
> >   1178  }
> 
> Dan,
> 
> I'm running smatch which is based on 6193b3b71beb ("extra: fix some error pointer handling")
> and I don't see this error. Should I run something special?
> 

This check is too crap to publish.

The heuristic was "a bitwise AND which always results in zero" but a lot
of code does stuff like:  "data = 0x00 << 0 | 0x04 << 8 | 0x12 << 16;"
I could never figure out a way to make the check useful enough to
publish.

regards,
dan carpenter

