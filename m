Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4BA570B0B
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 21:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiGKT7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 15:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGKT7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 15:59:12 -0400
X-Greylist: delayed 150 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 11 Jul 2022 12:59:10 PDT
Received: from resdmta-a1p-077302.sys.comcast.net (resdmta-a1p-077302.sys.comcast.net [IPv6:2001:558:fd01:2bb4::c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB733C8F6
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 12:59:09 -0700 (PDT)
Received: from resomta-a1p-076784.sys.comcast.net ([96.103.145.232])
        by resdmta-a1p-077302.sys.comcast.net with ESMTP
        id AtKLoIBynHzlAAzWHonPXm; Mon, 11 Jul 2022 19:56:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20211018a; t=1657569397;
        bh=CyUE7tQqtYJwZMbdJfYcucY8BQfL4m9TbjCYZM2+C7Q=;
        h=Received:Received:Message-ID:Date:MIME-Version:From:Subject:
         Reply-To:To:Content-Type;
        b=AirniwFyEzrs2hBu0Viskf9rnMJNShKU2h3b6OwQK4vtSDUXPy0I718FduEYy8A0P
         7eLkglJkv3kvnK9iLR+kAKwQ4DwCLTXvk+IZJWcB1+hNrwSPnJoFM0kfvCLriljmTD
         kLM0cdhAcsvLcOjzKbsqlZL1g214pKLQr2lU2rLdO1QJJbqu8lR4tHOuLyifD3aFQz
         G99y7IuXE1q8jW6BBNW12EyehCccs6WSCcbWr2m7Z4JhULK1LiFM3GkC8UmijfeNZJ
         TRJKbQx5tL9f5QvnrBVZLhyNuniEsLlZA8dpBBRINkIQic8Vl74obU6iw6v07vPs2R
         +enzc6h1vBfaA==
Received: from [IPV6:2001:558:6040:22:3412:4338:4dd2:4c2f]
 ([IPv6:2001:558:6040:22:3412:4338:4dd2:4c2f])
        by resomta-a1p-076784.sys.comcast.net with ESMTPSA
        id AzWFoYInMSWnSAzWGo1GEU; Mon, 11 Jul 2022 19:56:37 +0000
X-Xfinity-VMeta: sc=0.00;st=legit
Message-ID: <a44d49c8-a847-5efa-7ff1-4bea8cf6d5fc@nurealm.net>
Date:   Mon, 11 Jul 2022 13:56:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
From:   James Feeney <james@nurealm.net>
Subject: iproute2 - Feature Request - automatically distinguish IPv4/IPv6
 addresses in "ip rule"
Reply-To: james@nurealm.net
Content-Language: en-US
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I notice that "ip route" will automatically distinguish IPv4 and IPv6 addresses, so that "ip route add to <some IPv6 address>...", without the "-6" or "-family inet6", is acceptable, but that "ip rule add from <some IPv6 address> ...", without the "-6", will give "Error: Invalid source address." when referencing an IPv6 address.

Is that behavior with "ip rule" from something fundamental, or just a missing feature?

When feeding variables into an automated route and rule script for dual-stack configuration, an "ip route" template "just works" with both IPv4 and IPv6 addresses.  But "ip rule", in contrast, requires separate "ip rule" and "ip -6 rule" command templates for each address type.

Not a big deal, of course, but I thought I'd ask if "ip rule" could be made to automatically distinguish IPv4 and IPv6 address types, so that "ip rule" could simply "do the right thing", by itself, without having to specify the address family.

The ip(8) man page says, in reference to "protocol family", "If this option is not present, the protocol family is guessed from other arguments. If the rest of the command line does not give enough information to guess the family, ip falls back to the default one, usually inet or any."  So I'm guessing that the IPv6 address limitation with "ip rule" might simply be an oversight.
