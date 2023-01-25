Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6EA67B032
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbjAYKsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:48:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235655AbjAYKsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:48:36 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427EB56EFD
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:48:03 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id c4-20020a1c3504000000b003d9e2f72093so932579wma.1
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Sm7cAXvuksIT8Vn2KQfM6U5yXB3a8DRF5yFqF7/IqD8=;
        b=1DG9Q4JaxhWmDSfrx9wk2S4ODUu5D6gqvoB6VO/OCaz2SOQSO3tjWY73kamLORPcBs
         56QmJF4rzK2p74s4oX2uBD3waQUQ53Kixs4jk1ALWv+c5d9BHhh0ftllxk9dMguVzn5a
         B5XjxReIgyKyP0kQqfsJmKpnv49gQLWO/JicjGLQVJHavsgprJs7AW+l5VE1/9EJatep
         88ftE+66RVdR4tra/hy7oWcjZijq5eln7VYfBbp5GVADqPcnwu85xD5UsnbvBdbBGtHQ
         EZtRJsFpD9FgH2TxCxiufaMmnJkqbY8ybwCJlDoi6g4v1rATIQkY/un3sGjVCBd9vFiu
         DeUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sm7cAXvuksIT8Vn2KQfM6U5yXB3a8DRF5yFqF7/IqD8=;
        b=o6P6o/P4UAhlAdfGJXZF8wcDCBdWWwiIccOP4bNH8lw6dPHcWauWfSIDCqIFFbgwIo
         fdyji8kwiMUFa2PN9s9tJX3VkpK2GbXeaqiw/YVRCV5NFCQbsfA8zMewK78mP8qbkvAV
         c8nRT92MOganjS3HFW5M41QcYbMXkkvTox9M8hP1zjoT169Z3QPc/a7YtT+uHF7I/98+
         4PitY8VoRfb+g/UA2+VJGHp6oTZCu5TGMRbRZSGyJhhaDWeM7+guW5MeFCxApCv743Vc
         tm5fyTyzr0E7ofMIH8081YrvMgy0O1FMbhERtkR3XKR2UWe8yPv8gSlaragod9B9jTNB
         bT2A==
X-Gm-Message-State: AFqh2kpFgxRrCt9pzrmZJfoQjITKqvKtSxE1stSm83fvWjxZTkv1xJTO
        vZ/DWmN5qZF8ZWZ1OkIx3bOWLg==
X-Google-Smtp-Source: AMrXdXsG9G6gXlDwKCzRzfrFFehM2xBbZSrI5a0qX8I0kxu8fudTbJrBiiil6k+s843f+kkQHh9C+g==
X-Received: by 2002:a05:600c:a15:b0:3db:18a0:310f with SMTP id z21-20020a05600c0a1500b003db18a0310fmr25637661wmp.33.1674643679225;
        Wed, 25 Jan 2023 02:47:59 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id r1-20020a05600c424100b003d9a86a13bfsm1423692wmm.28.2023.01.25.02.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 02:47:58 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net-next 0/8] mptcp: add mixed v4/v6 support for the
 in-kernel PM
Date:   Wed, 25 Jan 2023 11:47:20 +0100
Message-Id: <20230123-upstream-net-next-pm-v4-v6-v1-0-43fac502bfbf@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALgI0WMC/0WNwQqDMBBEf0X23IUkBpH+SulhY7d1D6ZhkwZB/
 HdjofQwh8cwbzbIrMIZrt0GylWyvGMDe+lgmim+GOXRGJxxvbGux0/KRZkWjFxa1oJpweqxDhj
 sOPjRkg/GQBMEyoxBKU7zqfgNziopP2X9/t7+xX3fDwd82FWRAAAA
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
X-Mailer: b4 0.12.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2147;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=y7xt/jDxFXcJ15EgIkD8oBTqZDL9ojRU13M9eMUQTFQ=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj0QjdXadWm/alm36siF313JgJqm+QfrUf00BHhUMv
 Oqy+kBeJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY9EI3QAKCRD2t4JPQmmgc7g9D/
 49zFh8NUIeA1NRsjrUD0s0nvcXhkcm1uDs+xlatBCfkwwhyLVci2wWXKq9rEzynsV6Ff+IQe70UXwZ
 Bega11YJTkt84+t1DJCbQ8RW6m79vF3dETy7Huuv6yfSZjgtbaiv1rS/7Qy0dQSKkH3MOoHBSau9Gd
 CIx4MIY6OYi3Q2mn4wociPth1irrJ1bnU7YqWt9qtu1f3G8EaEPiBfYki7X6JPqi6dmJylb0Li5PZS
 /p2jUczI7ctJDWCGU3JTn42cgk5O6aKi5zqEKm2p6uLxdFhhd8x/Z36yLChfdO8dn5t28JHFqA5Z7K
 V4ybZ2x4yflm+GilYKxrnP9pn7ryn47k9Cumg2GPG7jT4E5LeEhvFIDjjFEMIDeFtVBdRi6VB3syG9
 hS4Ig5Us92VM82fFDxav6yMOsqzppwe45+oC/j7nOTDcESeGaWY4w3LUOAnUxYC77peICUM3p3wcyn
 z2oWhpcgsNmF79QnfONrsxeEDSBVNoqZWMLmYlldc8MmTrmjMCxmOyxu9NGyN+l3WjR6mA+wJ5F1Sy
 cEeqBi6wXxuOrFbCjgJcu4+IFY0XC8GlJAViBH1rF9rYocoR+VwF4HoHLoZm6FXYmxFIWU8gDImogL
 CB/IGVehkyu/rQwkYp45hdw3OUoZpa/yyVhNpIpWUIHLsvwPnQX+Hk4Dp+3w==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before these patches, the in-kernel Path-Manager would not allow, for
the same MPTCP connection, having a mix of subflows in v4 and v6.

MPTCP's RFC 8684 doesn't forbid that and it is even recommended to do so
as the path in v4 and v6 are likely different. Some networks are also
v4 or v6 only, we cannot assume they all have both v4 and v6 support.

Patch 1 then removes this artificial constraint in the in-kernel PM
currently enforcing there are no mixed subflows in place, either in
address announcement or in subflow creation areas.

Patch 2 makes sure the sk_ipv6only attribute is also propagated to
subflows, just in case a new PM wouldn't respect it.

Some selftests have also been added for the in-kernel PM (patch 3).

Patches 4 to 8 are just some cleanups and small improvements in the
printed messages in the userspace PM. It is not linked to the rest but
identified when working on a related patch modifying this selftest,
already in -net:

  commit 4656d72c1efa ("selftests: mptcp: userspace: validate v4-v6 subflows mix")

---
Matthieu Baerts (6):
      mptcp: propagate sk_ipv6only to subflows
      mptcp: userspace pm: use a single point of exit
      selftests: mptcp: userspace: print titles
      selftests: mptcp: userspace: refactor asserts
      selftests: mptcp: userspace: print error details if any
      selftests: mptcp: userspace: avoid read errors

Paolo Abeni (2):
      mptcp: let the in-kernel PM use mixed IPv4 and IPv6 addresses
      selftests: mptcp: add test-cases for mixed v4/v6 subflows

 net/mptcp/pm_netlink.c                            |  58 ++++----
 net/mptcp/pm_userspace.c                          |   5 +-
 net/mptcp/sockopt.c                               |   1 +
 tools/testing/selftests/net/mptcp/mptcp_join.sh   |  53 ++++++--
 tools/testing/selftests/net/mptcp/userspace_pm.sh | 153 +++++++++++++---------
 5 files changed, 171 insertions(+), 99 deletions(-)
---
base-commit: 4373a023e0388fc19e27d37f61401bce6ff4c9d7
change-id: 20230123-upstream-net-next-pm-v4-v6-b186481a4b00

Best regards,
-- 
Matthieu Baerts <matthieu.baerts@tessares.net>

