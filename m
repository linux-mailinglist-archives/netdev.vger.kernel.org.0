Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC033D87F3
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 08:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234736AbhG1GbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 02:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbhG1GbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 02:31:21 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFC7C061760
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 23:31:20 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id e2so1108131wrq.6
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 23:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2sikO5aRr1NDQb5gHgbAUAbkVT20NnWQ6REy/wyFQ0Q=;
        b=P1dCLwa3AWDUkGJG9eRBNNydz2hqYMJKPUJbMs/9qdnAcv/Nh6bjeM8KsuoXLmW6TM
         sxsHTlpjU+MaJ04nW6RGhlTgt0+oer3XZ9qOkDe0ZG5P8gQlpLTMwOe0v+e2x8qgEuvF
         OgkmlSNVgAyHm6tzr2ZeOlKGUEHvlYE/oP5iWvE2jusbNBO8zaMu0PKVqMC6cvYkU+0x
         DNiqRY3NlxbN7ANIKe2tVrPQ153nTIB8oHJLs5mF6dbQ5/hlkdPMb7oXINPNyrcjPpqG
         fKahskELtYx6nO7KHOXHZMnWlCXOC5rZaXiWKDH4FTnl6DqgT8s0f+L5jX4AUoQ+A+DM
         /gsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2sikO5aRr1NDQb5gHgbAUAbkVT20NnWQ6REy/wyFQ0Q=;
        b=YsK5S8gTA5MsqgXvsO91fSdIAQTVWQ8oyVdxsFNDXV3fKTDI03HP1Y/A9iEme1jHjp
         h3rfaj2PfQFqRAU8VqzHEWgSQONWvCzzmsLvLUGOnMtdQ6d51lECrLlLyh5vVugNojRN
         kKBLnmr5BhwvHA+begC31y8e1wyx1aFJhzZMkmGDIOLJ+Tv/Ep1w+mqJwIky3vvRddfW
         +7ymTaazeVtj5/foBHEvVmZY5x7TttX2r9jUh7jWtOwwXQ+J3G3iq8LJ3GHszGnA/jL3
         ZSyMG3xTnccIw02CfBOKh+OwNUwwP8vLEL8ZC5ExKXdyS9DybQPJOhdySohlhFVARPX9
         oiJg==
X-Gm-Message-State: AOAM532jybF5rSXM/m8ndI+aFx5N4bHezYxEKZWev1f4ogR+hl8+GXTG
        ALP7Sa8Xs2rUQtF158eiNesGOXbxOmJ09K+s062NGQ==
X-Google-Smtp-Source: ABdhPJw/U7UooKCP1nShfDCkTewER+b2bl9Nfymw9MYtHFM6cZmDTUyMvC/Jnsy4fJrr8c1x8mYdiJXberxqiNB79+E=
X-Received: by 2002:adf:f145:: with SMTP id y5mr5889545wro.102.1627453878745;
 Tue, 27 Jul 2021 23:31:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210728044930.65564-1-jjoseaquiless@gmail.com>
In-Reply-To: <20210728044930.65564-1-jjoseaquiless@gmail.com>
From:   David Gow <davidgow@google.com>
Date:   Wed, 28 Jul 2021 14:31:07 +0800
Message-ID: <CABVgOS=eLuR-vYEsWCMMjcmVeqY6dfTF37o_+HHj+LGKnT+gJA@mail.gmail.com>
Subject: Re: [PATCH v2] lib: use of kunit in test_parman.c
To:     =?UTF-8?Q?Jos=C3=A9_Aquiles_Guedes_de_Rezende?= 
        <jjoseaquiless@gmail.com>
Cc:     Jiri Pirko <jiri@nvidia.com>, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Daniel Latypov <dlatypov@google.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, ~lkcamp/patches@lists.sr.ht,
        Matheus Henrique de Souza Silva 
        <matheushenriquedesouzasilva@protonmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 12:55 PM Jos=C3=A9 Aquiles Guedes de Rezende
<jjoseaquiless@gmail.com> wrote:
>
> Convert the parman test module to use the KUnit test framework.
> This makes the test clearer by leveraging KUnit's assertion macros
> and test case definitions,as well as helps standardize on a testing frame=
work.
>
> Co-developed-by: Matheus Henrique de Souza Silva <matheushenriquedesouzas=
ilva@protonmail.com>
> Signed-off-by: Matheus Henrique de Souza Silva <matheushenriquedesouzasil=
va@protonmail.com>
> Signed-off-by: Jos=C3=A9 Aquiles Guedes de Rezende <jjoseaquiless@gmail.c=
om>
> ---
>
> Changes in v2:
> - Rename TEST_PARMAN config item to PARMAN_KUNIT_TEST
>   and make it work with the kunit framework.
> - Change KUNIT_ASSERT_EQ to KUNIT_ASSERT_EQ_MSG.
> - Call test_parman_resize(test_parman, 0) when parman_create fail
> - Remove kunit_kfree.
> - Remove "\n" in error messages
> - Remove casts to unsigned long
>

Awesome! This worked out-of-the-box for me, thanks!

I'll leave a more detailed review to someone who knows what parman is
better than I, but it looks good to me from a KUnit point of view.

Nevertheless, this is
Tested-by: David Gow <davidgow@google.com>

-- David

>  lib/Kconfig.debug |  13 +++--
>  lib/Makefile      |   2 +-
>  lib/test_parman.c | 145 +++++++++++++++++++---------------------------
>  3 files changed, 70 insertions(+), 90 deletions(-)
>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 831212722924..e68a27e5e5b0 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -2231,12 +2231,15 @@ config TEST_HASH
>  config TEST_IDA
>         tristate "Perform selftest on IDA functions"
>
> -config TEST_PARMAN
> -       tristate "Perform selftest on priority array manager"
> -       depends on PARMAN
> +config PARMAN_KUNIT_TEST
> +       tristate "Kunit test for priority array manager" if !KUNIT_ALL_TE=
STS
> +       select PARMAN
> +       depends on KUNIT
> +       default KUNIT_ALL_TESTS
>         help
> -         Enable this option to test priority array manager on boot
> -         (or module load).
> +         Enable this option to test priority array manager on boot.
> +         For more information on KUnit and unit tests in general please =
refer
> +         to the KUnit documentation in Documentation/dev-tools/kunit/.
>
>           If unsure, say N.
>
> diff --git a/lib/Makefile b/lib/Makefile
> index 5efd1b435a37..deb8946735e8 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -88,7 +88,7 @@ obj-$(CONFIG_TEST_BITMAP) +=3D test_bitmap.o
>  obj-$(CONFIG_TEST_STRSCPY) +=3D test_strscpy.o
>  obj-$(CONFIG_TEST_UUID) +=3D test_uuid.o
>  obj-$(CONFIG_TEST_XARRAY) +=3D test_xarray.o
> -obj-$(CONFIG_TEST_PARMAN) +=3D test_parman.o
> +obj-$(CONFIG_PARMAN_KUNIT_TEST) +=3D test_parman.o
>  obj-$(CONFIG_TEST_KMOD) +=3D test_kmod.o
>  obj-$(CONFIG_TEST_DEBUG_VIRTUAL) +=3D test_debug_virtual.o
>  obj-$(CONFIG_TEST_MEMCAT_P) +=3D test_memcat_p.o
> diff --git a/lib/test_parman.c b/lib/test_parman.c
> index 35e32243693c..512f874bc71c 100644
> --- a/lib/test_parman.c
> +++ b/lib/test_parman.c
> @@ -41,6 +41,8 @@
>  #include <linux/err.h>
>  #include <linux/random.h>
>  #include <linux/parman.h>
> +#include <linux/sched.h>
> +#include <kunit/test.h>
>
>  #define TEST_PARMAN_PRIO_SHIFT 7 /* defines number of prios for testing =
*/
>  #define TEST_PARMAN_PRIO_COUNT BIT(TEST_PARMAN_PRIO_SHIFT)
> @@ -91,12 +93,14 @@ struct test_parman {
>
>  static int test_parman_resize(void *priv, unsigned long new_count)
>  {
> +       struct kunit *test =3D current->kunit_test;
>         struct test_parman *test_parman =3D priv;
>         struct test_parman_item **prio_array;
>         unsigned long old_count;
>
>         prio_array =3D krealloc(test_parman->prio_array,
>                               ITEM_PTRS_SIZE(new_count), GFP_KERNEL);
> +       KUNIT_EXPECT_NOT_ERR_OR_NULL(test, prio_array);
>         if (new_count =3D=3D 0)
>                 return 0;
>         if (!prio_array)
> @@ -214,42 +218,41 @@ static void test_parman_items_fini(struct test_parm=
an *test_parman)
>         }
>  }
>
> -static struct test_parman *test_parman_create(const struct parman_ops *o=
ps)
> +static int test_parman_create(struct kunit *test)
>  {
>         struct test_parman *test_parman;
>         int err;
>
> -       test_parman =3D kzalloc(sizeof(*test_parman), GFP_KERNEL);
> -       if (!test_parman)
> -               return ERR_PTR(-ENOMEM);
> +       test_parman =3D kunit_kzalloc(test, sizeof(*test_parman), GFP_KER=
NEL);
> +       KUNIT_ASSERT_NOT_ERR_OR_NULL(test, test_parman);
> +
>         err =3D test_parman_resize(test_parman, TEST_PARMAN_BASE_COUNT);
> -       if (err)
> -               goto err_resize;
> -       test_parman->parman =3D parman_create(ops, test_parman);
> -       if (!test_parman->parman) {
> -               err =3D -ENOMEM;
> -               goto err_parman_create;
> +       KUNIT_ASSERT_EQ_MSG(test, err, 0, "test_parman_resize failed");
> +
> +       test_parman->parman =3D parman_create(&test_parman_lsort_ops, tes=
t_parman);
> +       if (IS_ERR_OR_NULL(test_parman->parman)) {
> +               test_parman_resize(test_parman, 0);
> +               KUNIT_ASSERT_NOT_ERR_OR_NULL(test, test_parman->parman);
>         }
> +
>         test_parman_rnd_init(test_parman);
>         test_parman_prios_init(test_parman);
>         test_parman_items_init(test_parman);
>         test_parman->run_budget =3D TEST_PARMAN_RUN_BUDGET;
> -       return test_parman;
> -
> -err_parman_create:
> -       test_parman_resize(test_parman, 0);
> -err_resize:
> -       kfree(test_parman);
> -       return ERR_PTR(err);
> +       test->priv =3D test_parman;
> +       return 0;
>  }
>
> -static void test_parman_destroy(struct test_parman *test_parman)
> +static void test_parman_destroy(struct kunit *test)
>  {
> +       struct test_parman *test_parman =3D test->priv;
> +
> +       if (!test_parman)
> +               return;
>         test_parman_items_fini(test_parman);
>         test_parman_prios_fini(test_parman);
>         parman_destroy(test_parman->parman);
>         test_parman_resize(test_parman, 0);
> -       kfree(test_parman);
>  }
>
>  static bool test_parman_run_check_budgets(struct test_parman *test_parma=
n)
> @@ -265,8 +268,9 @@ static bool test_parman_run_check_budgets(struct test=
_parman *test_parman)
>         return true;
>  }
>
> -static int test_parman_run(struct test_parman *test_parman)
> +static void test_parman_run(struct kunit *test)
>  {
> +       struct test_parman *test_parman =3D test->priv;
>         unsigned int i =3D test_parman_rnd_get(test_parman);
>         int err;
>
> @@ -281,8 +285,8 @@ static int test_parman_run(struct test_parman *test_p=
arman)
>                         err =3D parman_item_add(test_parman->parman,
>                                               &item->prio->parman_prio,
>                                               &item->parman_item);
> -                       if (err)
> -                               return err;
> +                       KUNIT_ASSERT_EQ_MSG(test, err, 0, "parman_item_ad=
d failed");
> +
>                         test_parman->prio_array[item->parman_item.index] =
=3D item;
>                         test_parman->used_items++;
>                 } else {
> @@ -294,22 +298,19 @@ static int test_parman_run(struct test_parman *test=
_parman)
>                 }
>                 item->used =3D !item->used;
>         }
> -       return 0;
>  }
>
> -static int test_parman_check_array(struct test_parman *test_parman,
> -                                  bool gaps_allowed)
> +static void test_parman_check_array(struct kunit *test, bool gaps_allowe=
d)
>  {
>         unsigned int last_unused_items =3D 0;
>         unsigned long last_priority =3D 0;
>         unsigned int used_items =3D 0;
>         int i;
> +       struct test_parman *test_parman =3D test->priv;
>
> -       if (test_parman->prio_array_limit < TEST_PARMAN_BASE_COUNT) {
> -               pr_err("Array limit is lower than the base count (%lu < %=
lu)\n",
> -                      test_parman->prio_array_limit, TEST_PARMAN_BASE_CO=
UNT);
> -               return -EINVAL;
> -       }
> +       KUNIT_ASSERT_GE_MSG(test, test_parman->prio_array_limit, TEST_PAR=
MAN_BASE_COUNT,
> +               "Array limit is lower than the base count (%lu < %lu)",
> +               test_parman->prio_array_limit, TEST_PARMAN_BASE_COUNT);
>
>         for (i =3D 0; i < test_parman->prio_array_limit; i++) {
>                 struct test_parman_item *item =3D test_parman->prio_array=
[i];
> @@ -318,77 +319,53 @@ static int test_parman_check_array(struct test_parm=
an *test_parman,
>                         last_unused_items++;
>                         continue;
>                 }
> -               if (last_unused_items && !gaps_allowed) {
> -                       pr_err("Gap found in array even though they are f=
orbidden\n");
> -                       return -EINVAL;
> -               }
> +
> +               KUNIT_ASSERT_FALSE_MSG(test, last_unused_items && !gaps_a=
llowed,
> +                       "Gap found in array even though they are forbidde=
n");
>
>                 last_unused_items =3D 0;
>                 used_items++;
>
> -               if (item->prio->priority < last_priority) {
> -                       pr_err("Item belongs under higher priority then t=
he last one (current: %lu, previous: %lu)\n",
> -                              item->prio->priority, last_priority);
> -                       return -EINVAL;
> -               }
> -               last_priority =3D item->prio->priority;
> +               KUNIT_ASSERT_GE_MSG(test, item->prio->priority, last_prio=
rity,
> +                       "Item belongs under higher priority then the last=
 one (current: %lu, previous: %lu)",
> +                       item->prio->priority, last_priority);
>
> -               if (item->parman_item.index !=3D i) {
> -                       pr_err("Item has different index in compare to wh=
ere it actually is (%lu !=3D %d)\n",
> -                              item->parman_item.index, i);
> -                       return -EINVAL;
> -               }
> -       }
> +               last_priority =3D item->prio->priority;
>
> -       if (used_items !=3D test_parman->used_items) {
> -               pr_err("Number of used items in array does not match (%u =
!=3D %u)\n",
> -                      used_items, test_parman->used_items);
> -               return -EINVAL;
> -       }
> +               KUNIT_ASSERT_EQ_MSG(test, item->parman_item.index, i,
> +                       "Item has different index in compare to where it =
actually is (%lu !=3D %d)",
> +                       item->parman_item.index, i);
>
> -       if (last_unused_items >=3D TEST_PARMAN_RESIZE_STEP_COUNT) {
> -               pr_err("Number of unused item at the end of array is bigg=
er than resize step (%u >=3D %lu)\n",
> -                      last_unused_items, TEST_PARMAN_RESIZE_STEP_COUNT);
> -               return -EINVAL;
>         }
>
> -       pr_info("Priority array check successful\n");
> +       KUNIT_ASSERT_EQ_MSG(test, used_items, test_parman->used_items,
> +               "Number of used items in array does not match (%u !=3D %u=
)",
> +               used_items, test_parman->used_items);
>
> -       return 0;
> +       KUNIT_ASSERT_LT_MSG(test, last_unused_items, TEST_PARMAN_RESIZE_S=
TEP_COUNT,
> +               "Number of unused item at the end of array is bigger than=
 resize step (%u >=3D %lu)",
> +               last_unused_items, TEST_PARMAN_RESIZE_STEP_COUNT);
>  }
>
> -static int test_parman_lsort(void)
> +static void test_parman_lsort(struct kunit *test)
>  {
> -       struct test_parman *test_parman;
> -       int err;
> -
> -       test_parman =3D test_parman_create(&test_parman_lsort_ops);
> -       if (IS_ERR(test_parman))
> -               return PTR_ERR(test_parman);
> -
> -       err =3D test_parman_run(test_parman);
> -       if (err)
> -               goto out;
> -
> -       err =3D test_parman_check_array(test_parman, false);
> -       if (err)
> -               goto out;
> -out:
> -       test_parman_destroy(test_parman);
> -       return err;
> +       test_parman_run(test);
> +       test_parman_check_array(test, false);
>  }
>
> -static int __init test_parman_init(void)
> -{
> -       return test_parman_lsort();
> -}
> +static struct kunit_case parman_test_case[] =3D {
> +       KUNIT_CASE(test_parman_lsort),
> +       {}
> +};
>
> -static void __exit test_parman_exit(void)
> -{
> -}
> +static struct kunit_suite parman_test_suite =3D {
> +       .name =3D "parman",
> +       .init =3D test_parman_create,
> +       .exit =3D test_parman_destroy,
> +       .test_cases =3D parman_test_case,
> +};
>
> -module_init(test_parman_init);
> -module_exit(test_parman_exit);
> +kunit_test_suite(parman_test_suite);
>
>  MODULE_LICENSE("Dual BSD/GPL");
>  MODULE_AUTHOR("Jiri Pirko <jiri@mellanox.com>");
> --
> 2.32.0
>
