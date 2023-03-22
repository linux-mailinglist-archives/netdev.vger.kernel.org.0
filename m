Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28A76C3EFE
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 01:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjCVAOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 20:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCVAOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 20:14:44 -0400
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A0631E35;
        Tue, 21 Mar 2023 17:14:42 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 32M0Dgof452698;
        Wed, 22 Mar 2023 01:13:42 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 32M0Dgof452698
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1679444022;
        bh=ftAdNGzckaGT6Ll8pv9l2TysMDC42QOH0a5wmX1LBI8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A3LngsaYlzqVm6+VPZxTVyOf/l6NZemuldwOjeLlocLnRr0iVwWvS1Ibl90Fu0yfd
         SHTa8RFFA87powusXd9AIhvKjfRW8cKiCIWeOitONRH82R62fAQhtQmqRqtNxwRDm4
         JLjXBe1PuKE6o2fYjkT/Eix66LBLsTPHAJ2nXsro=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 32M0Ddgp452695;
        Wed, 22 Mar 2023 01:13:39 +0100
Date:   Wed, 22 Mar 2023 01:13:38 +0100
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Bagas Sanjaya <bagasdotme@gmail.com>,
        Toke HHHiland-JJJrgensen <toke@redhat.com>, corbet@lwn.net,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        pisa@cmp.felk.cvut.cz, mkl@pengutronix.de,
        linux-doc@vger.kernel.org, f.fainelli@gmail.com,
        stephen@networkplumber.org
Subject: Re: [PATCH net-next v2] docs: networking: document NAPI
Message-ID: <20230322001338.GA452632@electric-eye.fr.zoreil.com>
References: <20230321050334.1036870-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321050334.1036870-1-kuba@kernel.org>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=3.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> :
[...]
> diff --git a/Documentation/networking/napi.rst b/Documentation/networking/napi.rst
> new file mode 100644
> index 000000000000..e9833f2b777a
> --- /dev/null
> +++ b/Documentation/networking/napi.rst
> @@ -0,0 +1,251 @@
> +.. _napi:
> +
> +====
> +NAPI
> +====
> +
> +NAPI is the event handling mechanism used by the Linux networking stack.
> +The name NAPI does not stand for anything in particular [#]_.
> +
> +In basic operation device notifies the host about new events via an interrupt.
> +The host then schedules a NAPI instance to process the events.
> +Device may also be polled for events via NAPI without receiving
> +interrupts first (:ref:`busy polling<poll>`).
> +
> +NAPI processing usually happens in the software interrupt context,
> +but user may choose to use :ref:`separate kernel threads<threaded>`
> +for NAPI processing.

NAPI processing also happens in the unusual context of netpoll.

I can't tell if it's better to be completely silent about it or to
explicitely state that it is beyond the scope of the document.

-- 
Ueimor
