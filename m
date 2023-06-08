Return-Path: <netdev+bounces-9333-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3015D7287DE
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:14:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81C991C2105D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 19:13:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AB691EA98;
	Thu,  8 Jun 2023 19:13:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2F214ABB
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 19:13:58 +0000 (UTC)
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FB33AB8
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 12:13:30 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id 5614622812f47-39a97058691so26854b6e.2
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 12:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1686251592; x=1688843592;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=P/de1cedCyPtEinl9mWpd4sdh2KODkQq/feW4vTz5Fk=;
        b=bah5YrRb+wMqZnYLm+OOci1fRQoQWcytsbN9wI5o/OclacmqYO8dfE6Zp0E3l+c6j/
         9pyremr1AoxxVda2LVTpSOEVNX/p7+GwFrKOv7DyC11b+VB1Ed9hThnblIPUlUm+gLJf
         1UQeN2z2MplRHIcF6NIRAL+tuFmkHpKl3oOye9z2eW1sJTKP9zgnV602cKjhBwDnpZ+x
         KsAz7ymG6P5/O8k1/1sYTmkuf3qATWrzaKGxQo0HIWzWygUiLe1HHFrGQ0ftX6Llkk8C
         UKQw+X3BgqsNFGXftXR2zihgHoEZZ8T5jmE2LICAfcBgGqcf3xzQlqOO2E5A8zK5tx/M
         7x/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686251592; x=1688843592;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P/de1cedCyPtEinl9mWpd4sdh2KODkQq/feW4vTz5Fk=;
        b=SIldlQBDh7jWrWhtmO4i7om1/hkEK5OyW+3JJfke4IkgcWojJjWyf/3dfe64YHcHwW
         kb8WBXOXW7dgmSHsXh24SAjHnt6teA57lFyNAH6q97MOccZWsLEQbl4fXbYn6XEyUQf3
         iDZjs1IORDzIC7i1FoHp5o8HTmobcX07Ne5dE9DkeS9a94YQRc2TecGM4piGD8O6X0Zo
         NtMvt/JY5duh1UDF73I15TPRpn4jRuHyuKaqHYt7OQTLbS0zI2uSJy2KND87O/IbLFo6
         798MJeyTBHx6j885ITJv3IHIzxZNR7ZXJ8ElJOdT8BVkAb8h1iXlr/wuGQydrm5/u1P+
         JmSQ==
X-Gm-Message-State: AC+VfDx8Edco3av7usX2lQ4cHW+WAJCBaAh9R8Z7sxYj+y+OMA/Q0eZO
	6YlRO01nRj6jVLS2Q3bHXkSBz0IFoUW4NyyJIg==
X-Google-Smtp-Source: ACHHUZ7FioTYCZKTrnk9LSeE0U1IKQAhZnLNONivnn5L80i3wi0Zm5yKhB4KMYFOlfsRjf+Ck+y25A==
X-Received: by 2002:a05:6808:690:b0:398:465e:ec62 with SMTP id k16-20020a056808069000b00398465eec62mr8654142oig.10.1686251592366;
        Thu, 08 Jun 2023 12:13:12 -0700 (PDT)
Received: from localhost (static-96-237-115-254.bstnma.fios.verizon.net. [96.237.115.254])
        by smtp.gmail.com with ESMTPSA id s5-20020a05621412c500b006255bcfca88sm623363qvv.7.2023.06.08.12.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 12:13:11 -0700 (PDT)
From: Paul Moore <paul@paul-moore.com>
To: linux-security-module@vger.kernel.org
Cc: netdev@vger.kernel.org
Subject: [PATCH] MAINTAINERS: move labeled networking to "supported"
Date: Thu,  8 Jun 2023 15:13:05 -0400
Message-ID: <20230608191304.253977-2-paul@paul-moore.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=955; i=paul@paul-moore.com; h=from:subject; bh=fpq2avy2Q7oHvRM6NWrM0gkmYad2cXL4M4knYStY49M=; b=owEBbQKS/ZANAwAIAeog8tqXN4lzAcsmYgBkgihAcw8YKcIAoYyCq6qnmfV4ewm8S0JrGQj7R PnwpCwdz/WJAjMEAAEIAB0WIQRLQqjPB/KZ1VSXfu/qIPLalzeJcwUCZIIoQAAKCRDqIPLalzeJ c8spD/0TO4oZspaTUp/bN5QCAQmXDJv5yJoLlpUGAJwKDOvyfxINQ6qsbZKVpmHrszfenMjbrBI hKZHaw3zKgvLCNi6U/X3aRPHc6+waNjxbUdKyT2brF7IpTJSnOpy5KlMKQvcCw8lATBRiT6XeCe Cck0JnvecJstv8TNW/tvTTQgwQT+0VHJZw/PuqiXB+6ghyvh1T8YBvzQwcH+OPWmZlk+Ezt33tt ey0oAK80OQkPzhi9mvD2AM0vO/9ds7+tBqunkrf4atHpzUYpH9tbxBQD/vWib7lkqaZY+f2MEUU OHoX6siVAldyhJ9DQ/uiZKZLXq1X57+jw5W9DOrPObBRdXjvEyExIqpJRw1DgGgJA5IGqxJuuzh L+IbQLefIfLPHaOHtJq0oQQ6tAdwU6BP+7HYZ8JptP9yt++PLpSNe9xY4pINkq6bvjRJSB/dGdL noLVMoMqrPtNDZDbzvcX7bYfGkZKArn56Nvrl0X80QXSMLZpPPoc8I5fAM+l6gBH5RGGE3HggWE OYCEZEn7jm9VzvwKXkoQIzK5VM1DHJWZTuCoC8R5ecuLZbKj5LK1A4SmWmCQFsLaFPTphIoG10O Yk8IEo1SoNyEeaipfdNanxDj8+SDXY8ZXDYgbmqKnvMP6Hj6sUxloAOATOgSVm+jXsYjqtuNQr4 U0W/5cqenqRuOjQ==
X-Developer-Key: i=paul@paul-moore.com; a=openpgp; fpr=7100AADFAE6E6E940D2E0AD655E45A5AE8CA7C8A
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

My current employer, Microsoft, cares very much about the development
and maintenance of the upstream Linux Kernel so we can consider
labeled networking to be "supported" according to the definition in
MAINTAINERS:

  S: *Status*, one of the following:
      Supported:  Someone is actually paid to look after this.
      Maintained: Someone actually looks after it.
      ...

Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7e0b87d5aa2e..8818cd866009 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14667,7 +14667,7 @@ NETWORKING [LABELED] (NetLabel, Labeled IPsec, SECMARK)
 M:	Paul Moore <paul@paul-moore.com>
 L:	netdev@vger.kernel.org
 L:	linux-security-module@vger.kernel.org
-S:	Maintained
+S:	Supported
 W:	https://github.com/netlabel
 F:	Documentation/netlabel/
 F:	include/net/calipso.h
-- 
2.41.0


