Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83F1A6D52D8
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbjDCUuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbjDCUuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:50:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335C026B9;
        Mon,  3 Apr 2023 13:50:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C35D662B2C;
        Mon,  3 Apr 2023 20:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1F5C433D2;
        Mon,  3 Apr 2023 20:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680555010;
        bh=0VZdHhGj0ajK/VONogM3wgSJQbG5wqIBJRbuGXnADCE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HFKbO2JmnCxTISDzAehT5gnqVdQcK5RXT/sFA55xgP8+nYg3mZPzQTCWwvbkaBzFW
         AmpImJivV1Ys2eZygcmEzHKAH8E7QDTz49JP4TeToW/Pti93tEVRxKCElY0yR1PDVz
         QmvWqqQOBFuV4rNro4YcGx+o07TuoNaeJz5uXHpyHFfDg8novuPhYbrqxP6FUZagT+
         bhR04mSjjgpj5nV1Qvn0QyVbdnGsQbeM/7Rdjupnyqegnh3IvX+AVOH4YAOjALcGtu
         O+4psUsFUYTrz7leLmNCjdcVBpt+4DrUO8ahy3Nz0nzJSdJmHekdM1el3pOfZQFGUd
         l2l2YvECRFZ9w==
Date:   Mon, 3 Apr 2023 13:50:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 1/6] netlink: Reverse the patch which removed
 filtering
Message-ID: <20230403135008.7f492aeb@kernel.org>
In-Reply-To: <4E631493-D61F-4778-A392-3399DF400A9D@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
        <20230331235528.1106675-2-anjali.k.kulkarni@oracle.com>
        <20230331210920.399e3483@kernel.org>
        <88FD5EFE-6946-42C4-881B-329C3FE01D26@oracle.com>
        <20230401121212.454abf11@kernel.org>
        <4E631493-D61F-4778-A392-3399DF400A9D@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2 Apr 2023 02:32:19 +0000 Anjali Kulkarni wrote:
> > Who are you hoping will merge this?  
> Could I request you to look into merging the patches which seem ok to
> you, since you are listed as the maintainer for these? I can make any
> more changes for the connector patches if you see the need..

The first two, you mean? We can merge them, but we need to know that
the rest is also going somewhere. Kernel has a rule against merging
APIs without any in-tree users, so we need a commitment that the
user will also reach linux-next before the merge window :(

Christian was commenting on previous releases maybe he can take or just
review the last 4 patches?
