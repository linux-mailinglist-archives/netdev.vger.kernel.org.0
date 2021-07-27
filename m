Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C373D83A6
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 01:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhG0XET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 19:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232314AbhG0XES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 19:04:18 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B89C061757;
        Tue, 27 Jul 2021 16:04:18 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d1so372380pll.1;
        Tue, 27 Jul 2021 16:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q3ZJt+Wpnzbxyfl1rdsalqa7Ct7UoX9NXUeeObi4Y4g=;
        b=c6YCWWROhD0FeAZm0Dic2NUHxwvyOkwaMUYE8oS2cYbXoVCGiRdur5HTKseH4TjHtJ
         A67kz1aTSUyVeHoLnShSXy6z1LOqaar9Q/RnwzvOPvOpWULU64ta1SixyADQFQ9kATLk
         XsDb90i9cEEHLC+zNVqNoj1khucGmEo3AwI70td5Eg5uoX6xvVikbIH3vauOz031Dm30
         S/14ODQCKaJzhKjPZ5ehlGy6kVw2kokYVVJZ9za1uftXdv2Yyt0e0NK1nGZElSV+HItS
         2GAQtfWpNf7UCOaq1/pUx1j9HtYCm5PlXRZ0sOqTlp5n/xtz7UO2UrYnwjFQ4Dlebk3T
         pFGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q3ZJt+Wpnzbxyfl1rdsalqa7Ct7UoX9NXUeeObi4Y4g=;
        b=sqx2vnCokRSbouV8nDae9ygsVfgOZ/u/3pEgi6usfriYzspocsyKkTbsfoSGI2uMwo
         NE5rvno5Jc/zeRIT1N/tIDxejDrC2NCki7McVSpXbSIeXcXnYG+POUinhtcQH1BP78m7
         mQ1vmlajAbn0QJqOOHg+7O3cIVfjWaMfS0fRIfKUJuAv2Uck4oIkHZGRQ9P1oR8TZ4kT
         /Wjis2hEJwS+SwMR3wt5shErdJFSuFylqbUajzGNUhZRgPadgMAtlODgQlgmSa6YGPtu
         F6IYxqIjeXX0B/7Jo2vFBH3uWcltmy3j00WOePSvVz67qJxl/xuuJ2reu0x9uJA1QqDS
         gVoQ==
X-Gm-Message-State: AOAM5300KqLqfOvqjvxTVljjCkbo1GZmXbrk5olhrSpExVva3czTTInC
        fB/KlJyD/7+y29PZDi6Y9Ts=
X-Google-Smtp-Source: ABdhPJyJlP0MjkBgCPy6VGqrPj+M2BMq0J0HLZtHoJGS++DTXr8bHlp9kOIKbYtR3Vjfu2200WDtIg==
X-Received: by 2002:a63:510d:: with SMTP id f13mr22412790pgb.308.1627427057634;
        Tue, 27 Jul 2021 16:04:17 -0700 (PDT)
Received: from localhost.localdomain ([189.6.25.18])
        by smtp.gmail.com with ESMTPSA id d22sm4112594pfq.177.2021.07.27.16.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 16:04:16 -0700 (PDT)
From:   =?UTF-8?q?Jos=C3=A9=20Aquiles=20Guedes=20de=20Rezende?= 
        <jjoseaquiless@gmail.com>
To:     Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        brendanhiggins@google.com, dlatypov@google.com,
        davidgow@google.com, linux-kselftest@vger.kernel.org,
        ~lkcamp/patches@lists.sr.ht,
        =?UTF-8?q?Jos=C3=A9=20Aquiles=20Guedes=20de=20Rezende?= 
        <jjoseaquiless@gmail.com>,
        Matheus Henrique de Souza Silva 
        <matheushenriquedesouzasilva@protonmail.com>
Subject: [PATCH] lib: use of kunit in test_parman.c
Date:   Tue, 27 Jul 2021 19:58:48 -0300
Message-Id: <20210727225847.22185-1-jjoseaquiless@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the parman test module to use the KUnit test framework.
This makes thetest clearer by leveraging KUnit's assertion macros
and test case definitions,as well as helps standardize on a testing framework.

Co-developed-by: Matheus Henrique de Souza Silva <matheushenriquedesouzasilva@protonmail.com>
Signed-off-by: Matheus Henrique de Souza Silva <matheushenriquedesouzasilva@protonmail.com>
Signed-off-by: José Aquiles Guedes de Rezende <jjoseaquiless@gmail.com>
---
 lib/test_parman.c | 145 +++++++++++++++++++---------------------------
 1 file changed, 60 insertions(+), 85 deletions(-)

diff --git a/lib/test_parman.c b/lib/test_parman.c
index 35e32243693c..bd5010f0a412 100644
--- a/lib/test_parman.c
+++ b/lib/test_parman.c
@@ -41,6 +41,8 @@
 #include <linux/err.h>
 #include <linux/random.h>
 #include <linux/parman.h>
+#include <linux/sched.h>
+#include <kunit/test.h>
 
 #define TEST_PARMAN_PRIO_SHIFT 7 /* defines number of prios for testing */
 #define TEST_PARMAN_PRIO_COUNT BIT(TEST_PARMAN_PRIO_SHIFT)
@@ -91,12 +93,14 @@ struct test_parman {
 
 static int test_parman_resize(void *priv, unsigned long new_count)
 {
+	struct kunit *test = current->kunit_test;
 	struct test_parman *test_parman = priv;
 	struct test_parman_item **prio_array;
 	unsigned long old_count;
 
 	prio_array = krealloc(test_parman->prio_array,
 			      ITEM_PTRS_SIZE(new_count), GFP_KERNEL);
+	KUNIT_EXPECT_NOT_ERR_OR_NULL(test, prio_array);
 	if (new_count == 0)
 		return 0;
 	if (!prio_array)
@@ -214,42 +218,39 @@ static void test_parman_items_fini(struct test_parman *test_parman)
 	}
 }
 
-static struct test_parman *test_parman_create(const struct parman_ops *ops)
+static int test_parman_create(struct kunit *test)
 {
 	struct test_parman *test_parman;
 	int err;
 
-	test_parman = kzalloc(sizeof(*test_parman), GFP_KERNEL);
-	if (!test_parman)
-		return ERR_PTR(-ENOMEM);
+	test_parman = kunit_kzalloc(test, sizeof(*test_parman), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, test_parman);
+
 	err = test_parman_resize(test_parman, TEST_PARMAN_BASE_COUNT);
-	if (err)
-		goto err_resize;
-	test_parman->parman = parman_create(ops, test_parman);
-	if (!test_parman->parman) {
-		err = -ENOMEM;
-		goto err_parman_create;
-	}
+	KUNIT_ASSERT_EQ(test, err, 0);
+
+	test_parman->parman = parman_create(&test_parman_lsort_ops, test_parman);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, test_parman->parman);
+
 	test_parman_rnd_init(test_parman);
 	test_parman_prios_init(test_parman);
 	test_parman_items_init(test_parman);
 	test_parman->run_budget = TEST_PARMAN_RUN_BUDGET;
-	return test_parman;
-
-err_parman_create:
-	test_parman_resize(test_parman, 0);
-err_resize:
-	kfree(test_parman);
-	return ERR_PTR(err);
+	test->priv = test_parman;
+	return 0;
 }
 
-static void test_parman_destroy(struct test_parman *test_parman)
+static void test_parman_destroy(struct kunit *test)
 {
+	struct test_parman *test_parman = test->priv;
+
+	if (!test_parman)
+		return;
 	test_parman_items_fini(test_parman);
 	test_parman_prios_fini(test_parman);
 	parman_destroy(test_parman->parman);
 	test_parman_resize(test_parman, 0);
-	kfree(test_parman);
+	kunit_kfree(test, test_parman);
 }
 
 static bool test_parman_run_check_budgets(struct test_parman *test_parman)
@@ -265,8 +266,9 @@ static bool test_parman_run_check_budgets(struct test_parman *test_parman)
 	return true;
 }
 
-static int test_parman_run(struct test_parman *test_parman)
+static void test_parman_run(struct kunit *test)
 {
+	struct test_parman *test_parman = test->priv;
 	unsigned int i = test_parman_rnd_get(test_parman);
 	int err;
 
@@ -281,8 +283,8 @@ static int test_parman_run(struct test_parman *test_parman)
 			err = parman_item_add(test_parman->parman,
 					      &item->prio->parman_prio,
 					      &item->parman_item);
-			if (err)
-				return err;
+			KUNIT_ASSERT_EQ(test, err, 0);
+
 			test_parman->prio_array[item->parman_item.index] = item;
 			test_parman->used_items++;
 		} else {
@@ -294,22 +296,19 @@ static int test_parman_run(struct test_parman *test_parman)
 		}
 		item->used = !item->used;
 	}
-	return 0;
 }
 
-static int test_parman_check_array(struct test_parman *test_parman,
-				   bool gaps_allowed)
+static void test_parman_check_array(struct kunit *test, bool gaps_allowed)
 {
 	unsigned int last_unused_items = 0;
 	unsigned long last_priority = 0;
 	unsigned int used_items = 0;
 	int i;
+	struct test_parman *test_parman = test->priv;
 
-	if (test_parman->prio_array_limit < TEST_PARMAN_BASE_COUNT) {
-		pr_err("Array limit is lower than the base count (%lu < %lu)\n",
-		       test_parman->prio_array_limit, TEST_PARMAN_BASE_COUNT);
-		return -EINVAL;
-	}
+	KUNIT_ASSERT_GE_MSG(test, test_parman->prio_array_limit, TEST_PARMAN_BASE_COUNT,
+		"Array limit is lower than the base count (%lu < %lu)\n",
+		test_parman->prio_array_limit, TEST_PARMAN_BASE_COUNT);
 
 	for (i = 0; i < test_parman->prio_array_limit; i++) {
 		struct test_parman_item *item = test_parman->prio_array[i];
@@ -318,77 +317,53 @@ static int test_parman_check_array(struct test_parman *test_parman,
 			last_unused_items++;
 			continue;
 		}
-		if (last_unused_items && !gaps_allowed) {
-			pr_err("Gap found in array even though they are forbidden\n");
-			return -EINVAL;
-		}
+
+		KUNIT_ASSERT_FALSE_MSG(test, last_unused_items && !gaps_allowed,
+			"Gap found in array even though they are forbidden\n");
 
 		last_unused_items = 0;
 		used_items++;
 
-		if (item->prio->priority < last_priority) {
-			pr_err("Item belongs under higher priority then the last one (current: %lu, previous: %lu)\n",
-			       item->prio->priority, last_priority);
-			return -EINVAL;
-		}
-		last_priority = item->prio->priority;
+		KUNIT_ASSERT_GE_MSG(test, item->prio->priority, last_priority,
+			"Item belongs under higher priority then the last one (current: %lu, previous: %lu)\n",
+			item->prio->priority, last_priority);
 
-		if (item->parman_item.index != i) {
-			pr_err("Item has different index in compare to where it actually is (%lu != %d)\n",
-			       item->parman_item.index, i);
-			return -EINVAL;
-		}
-	}
+		last_priority = item->prio->priority;
 
-	if (used_items != test_parman->used_items) {
-		pr_err("Number of used items in array does not match (%u != %u)\n",
-		       used_items, test_parman->used_items);
-		return -EINVAL;
-	}
+		KUNIT_ASSERT_EQ_MSG(test, item->parman_item.index, (unsigned long)i,
+			"Item has different index in compare to where it actually is (%lu != %d)\n",
+			item->parman_item.index, i);
 
-	if (last_unused_items >= TEST_PARMAN_RESIZE_STEP_COUNT) {
-		pr_err("Number of unused item at the end of array is bigger than resize step (%u >= %lu)\n",
-		       last_unused_items, TEST_PARMAN_RESIZE_STEP_COUNT);
-		return -EINVAL;
 	}
 
-	pr_info("Priority array check successful\n");
+	KUNIT_ASSERT_EQ_MSG(test, used_items, test_parman->used_items,
+		"Number of used items in array does not match (%u != %u)\n",
+		used_items, test_parman->used_items);
 
-	return 0;
+	KUNIT_ASSERT_LT_MSG(test, (unsigned long)last_unused_items, TEST_PARMAN_RESIZE_STEP_COUNT,
+		"Number of unused item at the end of array is bigger than resize step (%u >= %lu)\n",
+		last_unused_items, TEST_PARMAN_RESIZE_STEP_COUNT);
 }
 
-static int test_parman_lsort(void)
+static void test_parman_lsort(struct kunit *test)
 {
-	struct test_parman *test_parman;
-	int err;
-
-	test_parman = test_parman_create(&test_parman_lsort_ops);
-	if (IS_ERR(test_parman))
-		return PTR_ERR(test_parman);
-
-	err = test_parman_run(test_parman);
-	if (err)
-		goto out;
-
-	err = test_parman_check_array(test_parman, false);
-	if (err)
-		goto out;
-out:
-	test_parman_destroy(test_parman);
-	return err;
+	test_parman_run(test);
+	test_parman_check_array(test, false);
 }
 
-static int __init test_parman_init(void)
-{
-	return test_parman_lsort();
-}
+static struct kunit_case parman_test_case[] = {
+	KUNIT_CASE(test_parman_lsort),
+	{}
+};
 
-static void __exit test_parman_exit(void)
-{
-}
+static struct kunit_suite parman_test_suite = {
+	.name = "parman",
+	.init = test_parman_create,
+	.exit = test_parman_destroy,
+	.test_cases = parman_test_case,
+};
 
-module_init(test_parman_init);
-module_exit(test_parman_exit);
+kunit_test_suite(parman_test_suite);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Jiri Pirko <jiri@mellanox.com>");
-- 
2.32.0

