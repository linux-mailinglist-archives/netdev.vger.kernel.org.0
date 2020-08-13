Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CB52431CA
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 02:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgHMAv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 20:51:28 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54368 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbgHMAv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Aug 2020 20:51:28 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k61Sh-0001TG-LI; Thu, 13 Aug 2020 10:51:20 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Aug 2020 10:51:19 +1000
Date:   Thu, 13 Aug 2020 10:51:19 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Srujana Challa <schalla@marvell.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, schandran@marvell.com,
        pathreya@marvell.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com
Subject: Re: [PATCH v2 2/3] drivers: crypto: add support for OCTEONTX2 CPT
 engine
Message-ID: <20200813005119.GA24593@gondor.apana.org.au>
References: <1596809360-12597-1-git-send-email-schalla@marvell.com>
 <1596809360-12597-3-git-send-email-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596809360-12597-3-git-send-email-schalla@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 07, 2020 at 07:39:19PM +0530, Srujana Challa wrote:
>
> +/*
> + * On OcteonTX2 platform the parameter insts_num is used as a count of
> + * instructions to be enqueued. The valid values for insts_num are:
> + * 1 - 1 CPT instruction will be enqueued during LMTST operation
> + * 2 - 2 CPT instructions will be enqueued during LMTST operation
> + */
> +static inline void otx2_cpt_send_cmd(union otx2_cpt_inst_s *cptinst,
> +				     u32 insts_num, void *obj)
> +{
> +	struct otx2_cptlf_info *lf = obj;
> +	void *lmtline = lf->lmtline;
> +	long ret;
> +
> +	/*
> +	 * Make sure memory areas pointed in CPT_INST_S
> +	 * are flushed before the instruction is sent to CPT
> +	 */
> +	smp_wmb();

Why should this be a NOOP on UP?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
