Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D1D6E5C3F
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 10:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbjDRIha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 04:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbjDRIh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 04:37:26 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B658E4EE9;
        Tue, 18 Apr 2023 01:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=WswIqf/p9jGCc86OtNOZnjAnLShDxXLjLeY4Utbl7CQ=;
        t=1681807014; x=1683016614; b=hrNwl2cXNxYv8fHLJJl9w3V/Vy+qvfKK2h/RSx0EQ8YaLdR
        y7JVwUvtSqERTYTIviiRZp/ItWzJN6o4jBg6gVVlqNyiUn7bhrWUzPXIG9LVR7qLfLEIAqBdr5D5w
        xYREL1dNnCsN3fwkKbW+xAfsIn1Iw0EF3q1VvTOYAOhhbZc6d4d3lJvpv5OIvtQMyhMdHONgjYR6u
        1pHvfgEJ9i3dIfDk8Aj6+XpZ4vpuyFRUh23LK4e6wfl9BnkRDjwNZp8Eq6YKNbSKG3EovIyPZ5aP+
        JDRR1XVAH7B8J1k5Nrz5U9ntK7eTuJVI5AIt5YBEv+XiWl28C1lJhpGN/7kQCl1A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pogoy-001Xua-0f;
        Tue, 18 Apr 2023 10:36:16 +0200
Message-ID: <f23c038b2b586a45a8b3c757495d5bb51ee4ac7e.camel@sipsolutions.net>
Subject: Re: [PATCH] net: mac80211: use IS_ERR to check return value
From:   Johannes Berg <johannes@sipsolutions.net>
To:     yingsha xu <ysxu@hust.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Benc <jbenc@suse.cz>,
        "John W. Linville" <linville@tuxdriver.com>
Cc:     hust-os-kernel-patches@googlegroups.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 18 Apr 2023 10:36:14 +0200
In-Reply-To: <20230416083028.14044-1-ysxu@hust.edu.cn>
References: <20230416083028.14044-1-ysxu@hust.edu.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2023-04-16 at 16:30 +0800, yingsha xu wrote:
> According to the annotation of function debugfs_create_fs, if
> an error occurs, ERR_PTR(-ERROR) will be returned instead of
> a null pointer or zero value.
>=20
> Fix it by using IS_ERR().

I don't this this is right, or fixed anything ...

If debugfs indeed returned an ERR_PTR() value, then the later debugfs
adds will do nothing.

Since it doesn't look like debugfs_create_dir() can actually return NULL
these days (not sure it ever could), I guess we can even remove the
check.

But you could've just read the comment there too, to know what the NULL
check was about ...

johannes

