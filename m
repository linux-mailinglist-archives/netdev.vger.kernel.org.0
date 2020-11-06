Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0942F2A91BD
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 09:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgKFIqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 03:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgKFIqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 03:46:39 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85B4C0613CF;
        Fri,  6 Nov 2020 00:46:38 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id c27so407818qko.10;
        Fri, 06 Nov 2020 00:46:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d3ntAnKa8/mYLGzPmrDnpX+SS9nceIT0yXThvuLk7dA=;
        b=PeMII59gOf7WuG2rlMrNUnfKKkKYzZ7Ef8+qFoNOUO1MT13N9+2o8BRfkNPlszNr9Z
         pUtu9jzfVSLgV9O956BWD4k45Wz8Z2stMnaWCKoL9EdO0aEszica/DCfev6sTb1BAknl
         pfkRrR6MtV/tYlny/Cy2cujiB6W7qiviGEdZq42BeYry0fGG9FUqjgZaBhZWNZDo0GhR
         fGbn1lLLCLAWHz9sUD9A3YrCWOsvbc4QziPEbqREM4W3QswdwGk1vtqcMw2TU5LhGbI7
         kwEpMh/EzjhIS0R5uJFZ3WTVTja9+7L6htx4c18BL3Znpfu3aGTf3h7FGXLy9VBKnVwE
         U5RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d3ntAnKa8/mYLGzPmrDnpX+SS9nceIT0yXThvuLk7dA=;
        b=loC1CQgHFdATcGwriiIJJLkk4g0KICNBW08Pp74t/fdOcaf7RVV3LVou48dkbWDnzR
         2wWfEqZw+TNXJ/mYmkmNrb0QO7dBQ8ZMHd3XiwGAMj8LPBpe64ztgoPY8OdO08Dcf9fx
         mdv8euzjvqpakR1QBs19xf7TxoDX0pCUt06TgXmHm7BgtWgUe0lCHtzb71RF7eJNaziU
         0wtiWzVlOrvJETE6RG1P2rq2m89f98WdVas1qodtW99kznRIdg8DUBteGgxS185ARoNZ
         0ilfxp1mzepaaEGZ51BA/2/7ZQGR7ypD2wnpNAUjid81aU1C31FFVl1IrpWrzfHDOcPF
         D+vg==
X-Gm-Message-State: AOAM532qw91QUMMmruwuqGUeUBpkCAxa8y1Q4D+FsoD1UEnx1FtKa7lV
        fuxnGfi++fBq2Zky9IKSH3AGp6QuExoBrQ==
X-Google-Smtp-Source: ABdhPJzGjNx6q1Eui0yJdJ24MIkr65ePf5mdy58YV3RH3FKIUM0P+k+G7LaUPxrniWQj+SXrwj/UZg==
X-Received: by 2002:a37:9b48:: with SMTP id d69mr544640qke.435.1604652397999;
        Fri, 06 Nov 2020 00:46:37 -0800 (PST)
Received: from localhost.localdomain ([177.220.172.74])
        by smtp.gmail.com with ESMTPSA id r8sm188681qkm.115.2020.11.06.00.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 00:46:37 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id D4BF4C1B80; Fri,  6 Nov 2020 05:46:34 -0300 (-03)
Date:   Fri, 6 Nov 2020 05:46:34 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Petr Malat <oss@malat.biz>
Cc:     linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: Fix sending when PMTU is less than
 SCTP_DEFAULT_MINSEGMENT
Message-ID: <20201106084634.GA3556@localhost.localdomain>
References: <20201105103946.18771-1-oss@malat.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105103946.18771-1-oss@malat.biz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 11:39:47AM +0100, Petr Malat wrote:
> Function sctp_dst_mtu() never returns lower MTU than
> SCTP_TRUNC4(SCTP_DEFAULT_MINSEGMENT) even when the actual MTU is less,
> in which case we rely on the IP fragmentation and must enable it.

This should be being handled at sctp_packet_will_fit():

          psize = packet->size;
          if (packet->transport->asoc)
                  pmtu = packet->transport->asoc->pathmtu;
          else
                  pmtu = packet->transport->pathmtu;

          /* Decide if we need to fragment or resubmit later. */
          if (psize + chunk_len > pmtu) {
                  /* It's OK to fragment at IP level if any one of the following
                   * is true:
                   *      1. The packet is empty (meaning this chunk is greater
                   *         the MTU)
                   *      2. The packet doesn't have any data in it yet and data
                   *         requires authentication.
                   */
                  if (sctp_packet_empty(packet) ||
                      (!packet->has_data && chunk->auth)) {
                          /* We no longer do re-fragmentation.
                           * Just fragment at the IP layer, if we
                           * actually hit this condition
                           */
                          packet->ipfragok = 1;
                          goto out;
                  }

Why the above doesn't handle it already?

