Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0ECD7F5A1
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 13:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392118AbfHBLAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 07:00:31 -0400
Received: from correo.us.es ([193.147.175.20]:33604 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392192AbfHBLAb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 07:00:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8FBD3C1B2A
        for <netdev@vger.kernel.org>; Fri,  2 Aug 2019 13:00:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 802EC115101
        for <netdev@vger.kernel.org>; Fri,  2 Aug 2019 13:00:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 710EC64499; Fri,  2 Aug 2019 13:00:28 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5107E115101;
        Fri,  2 Aug 2019 13:00:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 02 Aug 2019 13:00:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.181.192])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E7A1C40705C3;
        Fri,  2 Aug 2019 13:00:25 +0200 (CEST)
Date:   Fri, 2 Aug 2019 13:00:23 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, marcelo.leitner@gmail.com,
        jiri@resnulli.us, wenxu@ucloud.cn, saeedm@mellanox.com,
        paulb@mellanox.com, gerlitz.or@gmail.com
Subject: Re: [PATCH net 0/2] flow_offload hardware priority fixes
Message-ID: <20190802110023.udfcxowe3vmihduq@salvia>
References: <20190801112817.24976-1-pablo@netfilter.org>
 <20190801172014.314a9d01@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801172014.314a9d01@cakuba.netronome.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

If the user specifies 'pref' in the new rule, then tc checks if there
is a tcf_proto object that matches this priority. If the tcf_proto
object does not exist, tc creates a tcf_proto object and it adds the
new rule to this tcf_proto.

In cls_flower, each tcf_proto only stores one single rule, so if the
user tries to add another rule with the same 'pref', cls_flower
returns EEXIST.

I'll prepare a new patchset not to map the priority to the netfilter
basechain priority, instead the rule priority will be internally
allocated for each new rule.

Thanks for your feedback.
