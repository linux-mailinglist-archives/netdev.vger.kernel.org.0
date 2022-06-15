Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82CAE54CA2A
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 15:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348764AbiFONri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 09:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349094AbiFONrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 09:47:32 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7018CFD0F;
        Wed, 15 Jun 2022 06:47:30 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 767EEC01F; Wed, 15 Jun 2022 15:47:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655300848; bh=PTWn0ePIiBvVGOdZ/hdnTNTan5t62u43ouHTaFlQjB4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jIBdiVhs8W2FnA3e6HcjsEbTjNRSjcVyVKNBw4eJNODKn7HNMNI7kdFh4TxplskDl
         95xeFHW5x7BarMqU7vL/vQFCdfslKCwUF+cKzkEgcmkVnTTm3N1Y66ZOH1vCTxjuQN
         2yF5djZsR7wUKJuHHoNXSkQaK4xVXczGDsM5fDa/EuXCitWVBGbiRkJgjoJRHkr3hZ
         Mpup6B/BLKP0oMlHAAAbBnkcZOJijZGHPfkvh10YDM9Q+65easqjM1LkFqYOs1OBMw
         PcsLHcZ2b7Px9lDgpcdlRugpn6bVUB6loOkiKy5ri4V/hdGtqkkgBBUEXi/qaz3odA
         yEYBW1fxUJv+A==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id D7477C009;
        Wed, 15 Jun 2022 15:47:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655300847; bh=PTWn0ePIiBvVGOdZ/hdnTNTan5t62u43ouHTaFlQjB4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BTZC5LFIbxPOpSpwwCAru9VxKRWjJR0MDK4kal2CkdFrZ1U7Jc+VPNLUsiwzI1bnm
         fLqiFYlrh87PTnYPEniRYakCTidt2BWiDSIV1YfegaMMEIg3wdnJxFXwQbXWewbdbS
         HZYnwcDJ0BGubKbumS/T7XQcSNmRv1JTxFsl2p7dvkWWPjHuZb20PRn/Zl5eLdo+x8
         IRiX1nU3AdpIHzxfLacyshOCVjoxGop4LIQlfd9JlssixeVvyxc2Ywo1ip9ecVjdJG
         w0asfP0HeoQz5H6JFnLfTX7+FrGzCrF076kHMFiUii+ZgRYc5rzlHVSYZkQ3bT4Ujl
         e9N6O+xjZCSuQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 3165c53a;
        Wed, 15 Jun 2022 13:47:20 +0000 (UTC)
Date:   Wed, 15 Jun 2022 22:47:05 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 04/06] 9p fid refcount: add p9_fid_get/put wrappers
Message-ID: <Yqni2QQg0uX9Lx13@codewreck.org>
References: <7044959.MN0D2SvuAq@silver>
 <20220615031647.1764797-1-asmadeus@codewreck.org>
 <21498866.auqpVWlHDa@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <21498866.auqpVWlHDa@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Wed, Jun 15, 2022 at 03:00:19PM +0200:
> > -	if (!fid || IS_ERR(fid)) {
> > -		pr_warn("%s (%d): Trying to clunk with invalid fid\n",
> > -			__func__, task_pid_nr(current));
> > -		dump_stack();
> > -		return 0;
> > -	}
> > -	if (!refcount_dec_and_test(&fid->count))
> > -		return 0;
> > -
> 
> I probably would have moved (and that way preserved) that sanity warning to 
> p9_fid_put(), but anyway LGTM.

The existing code was careful not to call clunk on error, but I consider
put() calls to be kind of like free in that it's better to make these
easy to call: this allowed patch 6 reworked most fs/ functions getting a
ref to just initialize fids to NULL and inconditionally call
p9_fid_put() before return.

I guess it's just a matter of preference ultimately, but I think that'll
make it a bit easier to not leak fids. Time will tell if this works :)

> Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>

Thanks for this and other reviews!

--
Dominique
