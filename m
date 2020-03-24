Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647AE191D9D
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 00:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgCXXn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 19:43:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37984 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbgCXXn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 19:43:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 18D5F159F6751;
        Tue, 24 Mar 2020 16:43:27 -0700 (PDT)
Date:   Tue, 24 Mar 2020 16:43:26 -0700 (PDT)
Message-Id: <20200324.164326.639594724461733845.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, ubraun@linux.ibm.com
Subject: Re: [PATCH net-next 01/11] s390/qeth: simplify RX buffer tracking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200324182448.95362-2-jwi@linux.ibm.com>
References: <20200324182448.95362-1-jwi@linux.ibm.com>
        <20200324182448.95362-2-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Mar 2020 16:43:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Tue, 24 Mar 2020 19:24:38 +0100

> +#define QDIO_ELEMENT_NO(buf, element)	(element - &buf->element[0])

Maybe this works, but I would strongly suggest against using a CPP
macro argument that is the same name for the singleton element on
the left branch of the expression as the struct member name on
the right side of the element.

Furthermore, as far as I can tell this is only used in one location
in the code, and for such a simple expression that is excessive.
