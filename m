Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDFA58E9BB
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 11:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbiHJJhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 05:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbiHJJhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 05:37:14 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EEC84EC7;
        Wed, 10 Aug 2022 02:37:12 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q9-20020a17090a2dc900b001f58bcaca95so1599801pjm.3;
        Wed, 10 Aug 2022 02:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=78dgYlqKO0ZvQjJz+sJd0671q+NGfvnDDEssu3bBwM0=;
        b=lQI08ncjvuLNvOWEIrCzsgcKgE2diNiQhT8iO8FvSLLMxYi9mCiO67CSzRUITu8LrB
         6Qinn3mOIdhfO4Yo8lA+blRSETuEGrdp3nzbzud4oM7pAaR3zKLqTHJ1s2MVZSi24aPO
         5lZAGgQnL717sdNqp2JFkR5rElvLbyQNeq4/cH7sJ6VfImDKU5rh8YgqAFAZr6rGxHCb
         cnQFjNUNFbhSznox4mcKEGPNdKFO+wP8WWLeswx3i+TuwBVYZFkzNVQiqbu25QrsuTCr
         DvZ7BEhcyuW5Nc/Gx2Humrtm3BxIPoHzopFS+r4rLMm7GQ3en8r9Ao1/fODPXoSVd/OM
         SJuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=78dgYlqKO0ZvQjJz+sJd0671q+NGfvnDDEssu3bBwM0=;
        b=pukuQfNqG8278BXUX3CTmYW4KNJ+XkjMHCIzXaTU0P3LqC9ArmxyDNet3+2aO8AzNE
         qR9+AuI8zJpKVeDzul4GGY1GaGpV1kqzDA6DoueJLcvnOli/ocwlW23rOx166E16scrR
         Z69MSNvl4tMzRyZ2BUUQn6uKNfzCXF3HjOrPHCOwEC5EQU22Hlrrr6ukEBWOBr7zzFZ5
         xnFVVt9PqWwNIEiHViGiZeoqIl/uFOJ5JW0XXYl7sDcjg4RbFc+ibSjnN0rOx35OJBHy
         wBwvevJW6hbxVK/uu8bJu2vEO9xzNl9KMUSwLj76XuEaa4yYwQ07iY+ktbO+2KIZrA6b
         fxcg==
X-Gm-Message-State: ACgBeo0lOz8QVaxvBpOHMN8lq+/TiknfOcBzdLuQpsIWFr4xRPImcsBW
        UfXuU7rFPIreVefcPC+raiQ=
X-Google-Smtp-Source: AA6agR7YjYI12tnWvDGyWPfOPcugQ8xdwNLGNRCSJzyQgzH6ZBvqYbBkOtqw4ycTVf9Dab7Eme6PpA==
X-Received: by 2002:a17:90b:b13:b0:1f3:7ab:35b2 with SMTP id bf19-20020a17090b0b1300b001f307ab35b2mr2813942pjb.118.1660124231738;
        Wed, 10 Aug 2022 02:37:11 -0700 (PDT)
Received: from engine.. ([106.212.112.163])
        by smtp.gmail.com with ESMTPSA id p14-20020a17090a2c4e00b001f754cd508dsm1130979pjm.35.2022.08.10.02.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 02:37:11 -0700 (PDT)
From:   Piyush Thange <pthange19@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     shuah@kernel.org, vladimir.oltean@nxp.com, idosch@nvidia.com,
        petrm@nvidia.com, troglobit@gmail.com, amcohen@nvidia.com,
        tobias@waldekranz.com, po-hsu.lin@canonical.com,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Piyush Thange <pthange19@gmail.com>
Subject: [PATCH] selftests:net:forwarding: Included install command
Date:   Wed, 10 Aug 2022 15:05:08 +0530
Message-Id: <20220810093508.33790-1-pthange19@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the execution is skipped due to "jq not installed" message then
the installation methods on different OS's have been provided with
this message.

Signed-off-by: Piyush Thange <pthange19@gmail.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 37ae49d47853..c4121856fe06 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -152,6 +152,14 @@ require_command()

 	if [[ ! -x "$(command -v "$cmd")" ]]; then
 		echo "SKIP: $cmd not installed"
+		if [[ $cmd == "jq" ]]; then
+			echo " Install on Debian based systems"
+			echo "	sudo apt -y install jq"
+			echo " Install on RHEL based systems"
+			echo "	sudo yum -y install jq"
+			echo " Install on Fedora based systems"
+			echo "	sudo dnf -y install jq"
+		fi
 		exit $ksft_skip
 	fi
 }
--
2.37.1

