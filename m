Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF59E63A9AC
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 14:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiK1NfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 08:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbiK1NfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 08:35:17 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A8E1EAC0
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 05:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/xlq2jKirm2n30vYvLD1krTXQIpgjhrn+4CCA31dpKY=; b=qKng43PbLjfET7UzXfgC60SD6O
        Pm0jEZTecCsA1gH7f6Ro5ncmxxgktw8q2QCrz6KsH7daKc2G+o8YoHhciJ10aVSndXWYYjRwMXoHO
        xEx1CjXQ+CBXFDQ8WeWLDju34Ra0kMGSpy8ZePjEoQVRnBO/1bTVF8ZwqvBmIwoApcVA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ozeHy-003ejZ-BB; Mon, 28 Nov 2022 14:35:14 +0100
Date:   Mon, 28 Nov 2022 14:35:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        yc-core@yandex-team.ru, lvc-project@linuxtesting.org
Subject: Re: [PATCH v1 3/3] net/ethtool/ioctl: correct & simplify
 ethtool_get_phy_stats if checks
Message-ID: <Y4S5EpZ3JrG0PstH@lunn.ch>
References: <20221125164913.360082-1-d-tatianin@yandex-team.ru>
 <20221125164913.360082-4-d-tatianin@yandex-team.ru>
 <Y4ETXbZn3wSnZbfh@lunn.ch>
 <55705e49-4b35-59be-5e41-7454dd12a0a4@yandex-team.ru>
 <Y4FO65aWvYu8Y6U7@lunn.ch>
 <11169dbe-2a26-6f31-3be6-f0439bb861f1@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11169dbe-2a26-6f31-3be6-f0439bb861f1@yandex-team.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I guess this does indeed look cleaner although I'm not sure about the
> duplicated n_stats validation code. Maybe this could be moved to a separate
> helper as well or do you think it's okay to duplicate it in this case?

Yes, the validation and the memory allocation could be pulled out into
a helper.

The main thing here is that the code is pretty much identical for the
two functions. If one is correct, the other is also correct. There is
no access in an else branch which can be overlooked.

  Andrew
