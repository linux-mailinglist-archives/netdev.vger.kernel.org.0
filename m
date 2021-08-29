Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665F93FAEC0
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 23:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236090AbhH2VfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 17:35:25 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:49247 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235483AbhH2VfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 17:35:25 -0400
Received: (Authenticated sender: n@nfraprado.net)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 9F334240003;
        Sun, 29 Aug 2021 21:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nfraprado.net;
        s=gm1; t=1630272870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Oe1wN4HGHqlI+QeKkYZRtxigAm09Uzo0GmesgaO4pnk=;
        b=blHvuymFu41YgDk62DteTZ/+x3TY9UkyyLDpmru6Gz1YtiPwUq12Bsq0Mul3LcxSoDnP6G
        2nXpxsc/0F6wkY2fNh4QcbTJOHLhMhIETpz1WIgRj64tww2BnvO+u4rRFmvqd1QSnrbUKM
        M+2fYBbSrYPsvSzYYdXEviSFSrYksBN5VJcm9+G/d/3Fz5KYeNx1xrIdm23GX1l6poP6P2
        fGqqPXAyDJTpK5jd2KKe/e6SSWo0X/AWKWhga79wO/9ikOVhnJCARaXnMiATlMZWfVODs2
        l+t5NRxJZ+7/wneSSjiyPME46FiwR/63pxp+NOBFyC37kZt1h60UaQA2AxLldA==
Date:   Sun, 29 Aug 2021 18:34:22 -0300
From:   =?utf-8?B?TsOtY29sYXMgRi4gUi4gQS4=?= Prado <n@nfraprado.net>
To:     Jiri Pirko <jiri@nvidia.com>
Cc:     =?utf-8?B?Sm9zw6k=?= Aquiles Guedes de Rezende 
        <jjoseaquiless@gmail.com>, Jiri Pirko <jiri@nvidia.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Daniel Latypov <dlatypov@google.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, ~lkcamp/patches@lists.sr.ht,
        Matheus Henrique de Souza Silva 
        <matheushenriquedesouzasilva@protonmail.com>
Subject: Re: [PATCH v2] lib: use of kunit in test_parman.c
Message-ID: <20210829213422.qmoutc43fjrcpdf6@notapiano>
References: <20210728044930.65564-1-jjoseaquiless@gmail.com>
 <CABVgOS=eLuR-vYEsWCMMjcmVeqY6dfTF37o_+HHj+LGKnT+gJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABVgOS=eLuR-vYEsWCMMjcmVeqY6dfTF37o_+HHj+LGKnT+gJA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Any update on the review of this patch? Jiri Pirko?

Thanks,
Nícolas

On Wed, Jul 28, 2021 at 02:31:07PM +0800, David Gow wrote:
> On Wed, Jul 28, 2021 at 12:55 PM José Aquiles Guedes de Rezende
> <jjoseaquiless@gmail.com> wrote:
> >
> > Convert the parman test module to use the KUnit test framework.
> > This makes the test clearer by leveraging KUnit's assertion macros
> > and test case definitions,as well as helps standardize on a testing framework.
> >
> > Co-developed-by: Matheus Henrique de Souza Silva <matheushenriquedesouzasilva@protonmail.com>
> > Signed-off-by: Matheus Henrique de Souza Silva <matheushenriquedesouzasilva@protonmail.com>
> > Signed-off-by: José Aquiles Guedes de Rezende <jjoseaquiless@gmail.com>
> > ---
> >
> > Changes in v2:
> > - Rename TEST_PARMAN config item to PARMAN_KUNIT_TEST
> >   and make it work with the kunit framework.
> > - Change KUNIT_ASSERT_EQ to KUNIT_ASSERT_EQ_MSG.
> > - Call test_parman_resize(test_parman, 0) when parman_create fail
> > - Remove kunit_kfree.
> > - Remove "\n" in error messages
> > - Remove casts to unsigned long
> >
> 
> Awesome! This worked out-of-the-box for me, thanks!
> 
> I'll leave a more detailed review to someone who knows what parman is
> better than I, but it looks good to me from a KUnit point of view.
> 
> Nevertheless, this is
> Tested-by: David Gow <davidgow@google.com>
> 
> -- David
> 
> >  lib/Kconfig.debug |  13 +++--
> >  lib/Makefile      |   2 +-
> >  lib/test_parman.c | 145 +++++++++++++++++++---------------------------
> >  3 files changed, 70 insertions(+), 90 deletions(-)
> >
> > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > index 831212722924..e68a27e5e5b0 100644
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -2231,12 +2231,15 @@ config TEST_HASH
> >  config TEST_IDA
> >         tristate "Perform selftest on IDA functions"
> >
> > -config TEST_PARMAN
> > -       tristate "Perform selftest on priority array manager"
> > -       depends on PARMAN
> > +config PARMAN_KUNIT_TEST
> > +       tristate "Kunit test for priority array manager" if !KUNIT_ALL_TESTS
> > +       select PARMAN
> > +       depends on KUNIT
> > +       default KUNIT_ALL_TESTS
> >         help
> > -         Enable this option to test priority array manager on boot
> > -         (or module load).
> > +         Enable this option to test priority array manager on boot.
> > +         For more information on KUnit and unit tests in general please refer
> > +         to the KUnit documentation in Documentation/dev-tools/kunit/.
> >
> >           If unsure, say N.
> >
> > diff --git a/lib/Makefile b/lib/Makefile
> > index 5efd1b435a37..deb8946735e8 100644
> > --- a/lib/Makefile
> > +++ b/lib/Makefile
> > @@ -88,7 +88,7 @@ obj-$(CONFIG_TEST_BITMAP) += test_bitmap.o
> >  obj-$(CONFIG_TEST_STRSCPY) += test_strscpy.o
> >  obj-$(CONFIG_TEST_UUID) += test_uuid.o
> >  obj-$(CONFIG_TEST_XARRAY) += test_xarray.o
> > -obj-$(CONFIG_TEST_PARMAN) += test_parman.o
> > +obj-$(CONFIG_PARMAN_KUNIT_TEST) += test_parman.o
> >  obj-$(CONFIG_TEST_KMOD) += test_kmod.o
> >  obj-$(CONFIG_TEST_DEBUG_VIRTUAL) += test_debug_virtual.o
> >  obj-$(CONFIG_TEST_MEMCAT_P) += test_memcat_p.o
> > diff --git a/lib/test_parman.c b/lib/test_parman.c
> > index 35e32243693c..512f874bc71c 100644
> > --- a/lib/test_parman.c
> > +++ b/lib/test_parman.c
> > @@ -41,6 +41,8 @@
> >  #include <linux/err.h>
> >  #include <linux/random.h>
> >  #include <linux/parman.h>
> > +#include <linux/sched.h>
> > +#include <kunit/test.h>
> >
> >  #define TEST_PARMAN_PRIO_SHIFT 7 /* defines number of prios for testing */
> >  #define TEST_PARMAN_PRIO_COUNT BIT(TEST_PARMAN_PRIO_SHIFT)
> > @@ -91,12 +93,14 @@ struct test_parman {
> >
> >  static int test_parman_resize(void *priv, unsigned long new_count)
> >  {
> > +       struct kunit *test = current->kunit_test;
> >         struct test_parman *test_parman = priv;
> >         struct test_parman_item **prio_array;
> >         unsigned long old_count;
> >
> >         prio_array = krealloc(test_parman->prio_array,
> >                               ITEM_PTRS_SIZE(new_count), GFP_KERNEL);
> > +       KUNIT_EXPECT_NOT_ERR_OR_NULL(test, prio_array);
> >         if (new_count == 0)
> >                 return 0;
> >         if (!prio_array)
> > @@ -214,42 +218,41 @@ static void test_parman_items_fini(struct test_parman *test_parman)
> >         }
> >  }
> >
> > -static struct test_parman *test_parman_create(const struct parman_ops *ops)
> > +static int test_parman_create(struct kunit *test)
> >  {
> >         struct test_parman *test_parman;
> >         int err;
> >
> > -       test_parman = kzalloc(sizeof(*test_parman), GFP_KERNEL);
> > -       if (!test_parman)
> > -               return ERR_PTR(-ENOMEM);
> > +       test_parman = kunit_kzalloc(test, sizeof(*test_parman), GFP_KERNEL);
> > +       KUNIT_ASSERT_NOT_ERR_OR_NULL(test, test_parman);
> > +
> >         err = test_parman_resize(test_parman, TEST_PARMAN_BASE_COUNT);
> > -       if (err)
> > -               goto err_resize;
> > -       test_parman->parman = parman_create(ops, test_parman);
> > -       if (!test_parman->parman) {
> > -               err = -ENOMEM;
> > -               goto err_parman_create;
> > +       KUNIT_ASSERT_EQ_MSG(test, err, 0, "test_parman_resize failed");
> > +
> > +       test_parman->parman = parman_create(&test_parman_lsort_ops, test_parman);
> > +       if (IS_ERR_OR_NULL(test_parman->parman)) {
> > +               test_parman_resize(test_parman, 0);
> > +               KUNIT_ASSERT_NOT_ERR_OR_NULL(test, test_parman->parman);
> >         }
> > +
> >         test_parman_rnd_init(test_parman);
> >         test_parman_prios_init(test_parman);
> >         test_parman_items_init(test_parman);
> >         test_parman->run_budget = TEST_PARMAN_RUN_BUDGET;
> > -       return test_parman;
> > -
> > -err_parman_create:
> > -       test_parman_resize(test_parman, 0);
> > -err_resize:
> > -       kfree(test_parman);
> > -       return ERR_PTR(err);
> > +       test->priv = test_parman;
> > +       return 0;
> >  }
> >
> > -static void test_parman_destroy(struct test_parman *test_parman)
> > +static void test_parman_destroy(struct kunit *test)
> >  {
> > +       struct test_parman *test_parman = test->priv;
> > +
> > +       if (!test_parman)
> > +               return;
> >         test_parman_items_fini(test_parman);
> >         test_parman_prios_fini(test_parman);
> >         parman_destroy(test_parman->parman);
> >         test_parman_resize(test_parman, 0);
> > -       kfree(test_parman);
> >  }
> >
> >  static bool test_parman_run_check_budgets(struct test_parman *test_parman)
> > @@ -265,8 +268,9 @@ static bool test_parman_run_check_budgets(struct test_parman *test_parman)
> >         return true;
> >  }
> >
> > -static int test_parman_run(struct test_parman *test_parman)
> > +static void test_parman_run(struct kunit *test)
> >  {
> > +       struct test_parman *test_parman = test->priv;
> >         unsigned int i = test_parman_rnd_get(test_parman);
> >         int err;
> >
> > @@ -281,8 +285,8 @@ static int test_parman_run(struct test_parman *test_parman)
> >                         err = parman_item_add(test_parman->parman,
> >                                               &item->prio->parman_prio,
> >                                               &item->parman_item);
> > -                       if (err)
> > -                               return err;
> > +                       KUNIT_ASSERT_EQ_MSG(test, err, 0, "parman_item_add failed");
> > +
> >                         test_parman->prio_array[item->parman_item.index] = item;
> >                         test_parman->used_items++;
> >                 } else {
> > @@ -294,22 +298,19 @@ static int test_parman_run(struct test_parman *test_parman)
> >                 }
> >                 item->used = !item->used;
> >         }
> > -       return 0;
> >  }
> >
> > -static int test_parman_check_array(struct test_parman *test_parman,
> > -                                  bool gaps_allowed)
> > +static void test_parman_check_array(struct kunit *test, bool gaps_allowed)
> >  {
> >         unsigned int last_unused_items = 0;
> >         unsigned long last_priority = 0;
> >         unsigned int used_items = 0;
> >         int i;
> > +       struct test_parman *test_parman = test->priv;
> >
> > -       if (test_parman->prio_array_limit < TEST_PARMAN_BASE_COUNT) {
> > -               pr_err("Array limit is lower than the base count (%lu < %lu)\n",
> > -                      test_parman->prio_array_limit, TEST_PARMAN_BASE_COUNT);
> > -               return -EINVAL;
> > -       }
> > +       KUNIT_ASSERT_GE_MSG(test, test_parman->prio_array_limit, TEST_PARMAN_BASE_COUNT,
> > +               "Array limit is lower than the base count (%lu < %lu)",
> > +               test_parman->prio_array_limit, TEST_PARMAN_BASE_COUNT);
> >
> >         for (i = 0; i < test_parman->prio_array_limit; i++) {
> >                 struct test_parman_item *item = test_parman->prio_array[i];
> > @@ -318,77 +319,53 @@ static int test_parman_check_array(struct test_parman *test_parman,
> >                         last_unused_items++;
> >                         continue;
> >                 }
> > -               if (last_unused_items && !gaps_allowed) {
> > -                       pr_err("Gap found in array even though they are forbidden\n");
> > -                       return -EINVAL;
> > -               }
> > +
> > +               KUNIT_ASSERT_FALSE_MSG(test, last_unused_items && !gaps_allowed,
> > +                       "Gap found in array even though they are forbidden");
> >
> >                 last_unused_items = 0;
> >                 used_items++;
> >
> > -               if (item->prio->priority < last_priority) {
> > -                       pr_err("Item belongs under higher priority then the last one (current: %lu, previous: %lu)\n",
> > -                              item->prio->priority, last_priority);
> > -                       return -EINVAL;
> > -               }
> > -               last_priority = item->prio->priority;
> > +               KUNIT_ASSERT_GE_MSG(test, item->prio->priority, last_priority,
> > +                       "Item belongs under higher priority then the last one (current: %lu, previous: %lu)",
> > +                       item->prio->priority, last_priority);
> >
> > -               if (item->parman_item.index != i) {
> > -                       pr_err("Item has different index in compare to where it actually is (%lu != %d)\n",
> > -                              item->parman_item.index, i);
> > -                       return -EINVAL;
> > -               }
> > -       }
> > +               last_priority = item->prio->priority;
> >
> > -       if (used_items != test_parman->used_items) {
> > -               pr_err("Number of used items in array does not match (%u != %u)\n",
> > -                      used_items, test_parman->used_items);
> > -               return -EINVAL;
> > -       }
> > +               KUNIT_ASSERT_EQ_MSG(test, item->parman_item.index, i,
> > +                       "Item has different index in compare to where it actually is (%lu != %d)",
> > +                       item->parman_item.index, i);
> >
> > -       if (last_unused_items >= TEST_PARMAN_RESIZE_STEP_COUNT) {
> > -               pr_err("Number of unused item at the end of array is bigger than resize step (%u >= %lu)\n",
> > -                      last_unused_items, TEST_PARMAN_RESIZE_STEP_COUNT);
> > -               return -EINVAL;
> >         }
> >
> > -       pr_info("Priority array check successful\n");
> > +       KUNIT_ASSERT_EQ_MSG(test, used_items, test_parman->used_items,
> > +               "Number of used items in array does not match (%u != %u)",
> > +               used_items, test_parman->used_items);
> >
> > -       return 0;
> > +       KUNIT_ASSERT_LT_MSG(test, last_unused_items, TEST_PARMAN_RESIZE_STEP_COUNT,
> > +               "Number of unused item at the end of array is bigger than resize step (%u >= %lu)",
> > +               last_unused_items, TEST_PARMAN_RESIZE_STEP_COUNT);
> >  }
> >
> > -static int test_parman_lsort(void)
> > +static void test_parman_lsort(struct kunit *test)
> >  {
> > -       struct test_parman *test_parman;
> > -       int err;
> > -
> > -       test_parman = test_parman_create(&test_parman_lsort_ops);
> > -       if (IS_ERR(test_parman))
> > -               return PTR_ERR(test_parman);
> > -
> > -       err = test_parman_run(test_parman);
> > -       if (err)
> > -               goto out;
> > -
> > -       err = test_parman_check_array(test_parman, false);
> > -       if (err)
> > -               goto out;
> > -out:
> > -       test_parman_destroy(test_parman);
> > -       return err;
> > +       test_parman_run(test);
> > +       test_parman_check_array(test, false);
> >  }
> >
> > -static int __init test_parman_init(void)
> > -{
> > -       return test_parman_lsort();
> > -}
> > +static struct kunit_case parman_test_case[] = {
> > +       KUNIT_CASE(test_parman_lsort),
> > +       {}
> > +};
> >
> > -static void __exit test_parman_exit(void)
> > -{
> > -}
> > +static struct kunit_suite parman_test_suite = {
> > +       .name = "parman",
> > +       .init = test_parman_create,
> > +       .exit = test_parman_destroy,
> > +       .test_cases = parman_test_case,
> > +};
> >
> > -module_init(test_parman_init);
> > -module_exit(test_parman_exit);
> > +kunit_test_suite(parman_test_suite);
> >
> >  MODULE_LICENSE("Dual BSD/GPL");
> >  MODULE_AUTHOR("Jiri Pirko <jiri@mellanox.com>");
> > --
> > 2.32.0
> >
