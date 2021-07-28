Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB79C3D8463
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 02:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbhG1AEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 20:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbhG1AEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 20:04:22 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8148AC061760
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 17:04:21 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id m13so473551lfg.13
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 17:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6NKXH5NngvCX3SrO3Bblljes2ppPfbzXTrrGLcmdq3g=;
        b=IezXySxWf0nj30KrwBtXngbmO/DQBfeuIXvfSyeskecCbN2I9yfATgtMFa9mX9WMnw
         tKfUl42EyXLt0sMmwqF+QngWwHQsU19wy7y0Q6MbY6AkbpbJG4uSBt1hfB+8d+bRERaW
         NZIexiKBxMWiByltxu0/umFdLvNffIwFqXG0TPmDc/XEIAKgCQmWpKxLAXO6U8Q/ElGs
         Icux3kIR5HYvbWNKVSfYL7xphmdXeTZ8ksaimksTrTNlEeJ1pJk6ZC8UVXTWR4NLHVQR
         neRHoPL0IrtaHzpnGOmf0g/tyb9VYC05StdqT5Ct9nOH3P5HfNXv0HdiHDW2xbb0C1No
         +t8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6NKXH5NngvCX3SrO3Bblljes2ppPfbzXTrrGLcmdq3g=;
        b=WHFq81GcVBhTMc3MPT+v7S4tONXuA+SBS5XxcmU9KPoKxRKWn8CfYDW7nFEkjrmyqm
         AB6A3zc4WTzsyVW9j0TGqyxTkK1mxWT8IVrzRrM7gEGZM2HRv4hMJk2/6MlLN7/F8720
         a4BolZtXQo1H7gRY8vAtTR+d/c76GzO5CIlxklqhVvc65axL8njWWrSoMyJTceGYcarV
         v8LK2NCC4eiRyh2ijqceVwdGCKT7EO4nrZ0gqXyVvr08wLY/cdrvlfk30tWJWi2bBo4A
         xhpalJIhFC02Bf3K0FBY0WjRk8Sg1MrCzJT/ljBq4Ikw0Y4bG8pHb26gDgjXvGEQSf3b
         d71g==
X-Gm-Message-State: AOAM530VqN1sLcfh3j8yfT10BAIbjaAgFLzk2o2IiXnkd5kML02sgh26
        mh24K3CzqHW9fUAijO/v28d9kuwMwxtlf17Q7+k3Sw==
X-Google-Smtp-Source: ABdhPJyYupcpD2ZIPSN4FWysxPzhN1P73ZtKWB4Ad+7+7c5fwinREQG+3iU73LlNO6OON2SOBSJpiX2kbW6wqwY6/Yc=
X-Received: by 2002:a05:6512:744:: with SMTP id c4mr17839175lfs.596.1627430659494;
 Tue, 27 Jul 2021 17:04:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210727225847.22185-1-jjoseaquiless@gmail.com>
In-Reply-To: <20210727225847.22185-1-jjoseaquiless@gmail.com>
From:   Daniel Latypov <dlatypov@google.com>
Date:   Tue, 27 Jul 2021 17:04:08 -0700
Message-ID: <CAGS_qxr2yZmcZRGF3qg9eSqOAwCj3+CD4Gyc8cgTXydRToDckw@mail.gmail.com>
Subject: Re: [PATCH] lib: use of kunit in test_parman.c
To:     =?UTF-8?Q?Jos=C3=A9_Aquiles_Guedes_de_Rezende?= 
        <jjoseaquiless@gmail.com>
Cc:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brendanhiggins@google.com,
        davidgow@google.com, linux-kselftest@vger.kernel.org,
        ~lkcamp/patches@lists.sr.ht,
        Matheus Henrique de Souza Silva 
        <matheushenriquedesouzasilva@protonmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 4:04 PM Jos=C3=A9 Aquiles Guedes de Rezende
<jjoseaquiless@gmail.com> wrote:
>
> Convert the parman test module to use the KUnit test framework.
> This makes thetest clearer by leveraging KUnit's assertion macros

nit: s/thetest/the test

> and test case definitions,as well as helps standardize on a testing frame=
work.
>
> Co-developed-by: Matheus Henrique de Souza Silva <matheushenriquedesouzas=
ilva@protonmail.com>
> Signed-off-by: Matheus Henrique de Souza Silva <matheushenriquedesouzasil=
va@protonmail.com>
> Signed-off-by: Jos=C3=A9 Aquiles Guedes de Rezende <jjoseaquiless@gmail.c=
om>

Acked-by: Daniel Latypov <dlatypov@google.com>

I just briefly looked over the usage of KUnit a bit and left some suggestio=
ns.

It's nice to see the use of current->kunit_test in an ops struct.
I wrote that up as a potential use case in commit 359a376081d4
("kunit: support failure from dynamic analysis tools"), and I think
this is the first example of it being used as such :)

> ---
>  lib/test_parman.c | 145 +++++++++++++++++++---------------------------
>  1 file changed, 60 insertions(+), 85 deletions(-)
>
> diff --git a/lib/test_parman.c b/lib/test_parman.c
> index 35e32243693c..bd5010f0a412 100644
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
> @@ -214,42 +218,39 @@ static void test_parman_items_fini(struct test_parm=
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

Would it be clearer to do

KUNIT_ASSERT_EQ(test, 0, test_parman_resize(test_parman,
TEST_PARMAN_BASE_COUNT));

or change the line below to:

KUNIT_ASSERT_EQ_MSG(test, err, 0, "test_parman_resize failed");

Otherwise, if the test fails there, the error message isn't too clear.

> -       if (err)
> -               goto err_resize;
> -       test_parman->parman =3D parman_create(ops, test_parman);
> -       if (!test_parman->parman) {
> -               err =3D -ENOMEM;
> -               goto err_parman_create;
> -       }
> +       KUNIT_ASSERT_EQ(test, err, 0);
> +
> +       test_parman->parman =3D parman_create(&test_parman_lsort_ops, tes=
t_parman);
> +       KUNIT_ASSERT_NOT_ERR_OR_NULL(test, test_parman->parman);

Hmm, this won't call `test_parman_resize(test_parman, 0)` on error
like it did before.

Unfortunately, KUnit is a bit clunky for cases like this right now,
where there's cleanups that need to happen but aren't handle already
by the resource API (the underlying thing behind kunit_kzalloc that
frees the mem).

We could do something like

if (IS_ERR_OR_NULL(test_parman->parman)) {
  // we can use KUNIT_FAIL to just directly fail the test, or use the
assert macro for the autogenerated failure message
  KUNIT_FAIL(test, "....") / KUNIT_EXPECT_NOT_ERR_OR_NULL(test, ...);
  goto err_parman_create;
}


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
> +       kunit_kfree(test, test_parman);

This works as-is, but FYI, it isn't necessary as we've used
kunit_kzalloc() to allocate it above.
When the test exists, it'll automatically call this function, basically.

>  }
>
>  static bool test_parman_run_check_budgets(struct test_parman *test_parma=
n)
> @@ -265,8 +266,9 @@ static bool test_parman_run_check_budgets(struct test=
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
> @@ -281,8 +283,8 @@ static int test_parman_run(struct test_parman *test_p=
arman)
>                         err =3D parman_item_add(test_parman->parman,
>                                               &item->prio->parman_prio,
>                                               &item->parman_item);
> -                       if (err)
> -                               return err;
> +                       KUNIT_ASSERT_EQ(test, err, 0);

Echoing my suggestion above, we can either do
  KUNIT_ASSERT_EQ(test, 0, parman_item_add(...));
or something like
  KUNIT_ASSERT_EQ_MSG(test, err, 0, "parman_item_add failed")

> +
>                         test_parman->prio_array[item->parman_item.index] =
=3D item;
>                         test_parman->used_items++;
>                 } else {
> @@ -294,22 +296,19 @@ static int test_parman_run(struct test_parman *test=
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
> +               "Array limit is lower than the base count (%lu < %lu)\n",
> +               test_parman->prio_array_limit, TEST_PARMAN_BASE_COUNT);
>
>         for (i =3D 0; i < test_parman->prio_array_limit; i++) {
>                 struct test_parman_item *item =3D test_parman->prio_array=
[i];
> @@ -318,77 +317,53 @@ static int test_parman_check_array(struct test_parm=
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
n\n");

FYI, you don't need the \n for these.
KUnit will put one automatically.

Ditto for the other instances.

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
 one (current: %lu, previous: %lu)\n",
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
> +               KUNIT_ASSERT_EQ_MSG(test, item->parman_item.index, (unsig=
ned long)i,
> +                       "Item has different index in compare to where it =
actually is (%lu !=3D %d)\n",
> +                       item->parman_item.index, i);

Note: the cast to `unsigned long` here shouldn't be necessary anymore,
I don't think.
See 6e62dfa6d14f ("kunit: Do not typecheck binary assertions").


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
)\n",
> +               used_items, test_parman->used_items);
>
> -       return 0;
> +       KUNIT_ASSERT_LT_MSG(test, (unsigned long)last_unused_items, TEST_=
PARMAN_RESIZE_STEP_COUNT,
> +               "Number of unused item at the end of array is bigger than=
 resize step (%u >=3D %lu)\n",
> +               last_unused_items, TEST_PARMAN_RESIZE_STEP_COUNT);

ditto here, I think the casting can be dropped now.


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
