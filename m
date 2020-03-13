Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD1C18525A
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 00:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbgCMXba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 19:31:30 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40165 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727546AbgCMXb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 19:31:29 -0400
Received: by mail-pl1-f195.google.com with SMTP id h11so5037683plk.7
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 16:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SRUz9o5a9X7A/PJ9D/hoAO95xMB24tVhcCotAVZR5XU=;
        b=RBY7p3+waBtR8HgazNRqOEYGK+HGrUDVgkprMHdFtZIVkmxKENHmMFpjA70CoHlqi3
         Zxkl6LpvSR22zUJ/QadSbf6YTeF5MP03wag3w3pquAb/E0SStHNcRcRIPjqEgqCYM0A+
         3au3dz2C6Fwi4RB/IRC5I+jFQ0VxV619ZqdlY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SRUz9o5a9X7A/PJ9D/hoAO95xMB24tVhcCotAVZR5XU=;
        b=q5REicih/+xYQv/E1NUbX7Xf2rYiTNJgXwGilm3uqOBWMKxG9zdJVd3WDVLCrpILe5
         zyFx5kusOijIdHuNobxBJy7Ew0/iNVjS1EXaoOBVtzdfSwn24HSZWfxRApVOOxJXQVDl
         lnnajMlEVbyVE0HRtR4A1AAusqMs0LXhN2PQprG9xG6fsbS/bZKZDdY87/tvmBNAonE4
         WWcwOzXUIxsiEU42J7lXDXsBGL2h7up9eEfuTh+AoG+tyPNNXrSYLEZf9QX247LmU3AR
         k0hvQ3ZqLaD+Uuq7DrJhCz1CUaJyatcPyQEM3xTjsrDAnvLCSiSXgxwHT0e/rKVuDsuE
         1WyA==
X-Gm-Message-State: ANhLgQ2vfCYfh0fF2N4LVRjeDvxIcsAK6sYt2UGDNOBGF8fHydwfM7+o
        TOxe/6FMgA3d8JgtAxiTLDeFwVoLOTQ=
X-Google-Smtp-Source: ADFU+vuuMwY/cT/aGhTA0gaXcy3OxPWVCiq5mrECClF2HD8y6SMGjNxqp6E8GZDY5Ccs3NyjJriGpQ==
X-Received: by 2002:a17:902:7d8f:: with SMTP id a15mr15795135plm.107.1584142287758;
        Fri, 13 Mar 2020 16:31:27 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d2sm13405936pjo.45.2020.03.13.16.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 16:31:26 -0700 (PDT)
Date:   Fri, 13 Mar 2020 16:31:25 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     shuah@kernel.org, luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 4/5] kselftest: add fixture parameters
Message-ID: <202003131628.77119E4F4E@keescook>
References: <20200313031752.2332565-1-kuba@kernel.org>
 <20200313031752.2332565-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313031752.2332565-5-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 08:17:51PM -0700, Jakub Kicinski wrote:
> Allow users to pass parameters to fixtures.
> 
> Each fixture will be evaluated for each of its parameter
> sets.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  Documentation/dev-tools/kselftest.rst       |   3 +-
>  tools/testing/selftests/kselftest_harness.h | 159 ++++++++++++++++----
>  2 files changed, 135 insertions(+), 27 deletions(-)
> 
> diff --git a/Documentation/dev-tools/kselftest.rst b/Documentation/dev-tools/kselftest.rst
> index 61ae13c44f91..3c41f7494762 100644
> --- a/Documentation/dev-tools/kselftest.rst
> +++ b/Documentation/dev-tools/kselftest.rst
> @@ -301,7 +301,8 @@ Helpers
>  
>  .. kernel-doc:: tools/testing/selftests/kselftest_harness.h
>      :functions: TH_LOG TEST TEST_SIGNAL FIXTURE FIXTURE_DATA FIXTURE_SETUP
> -                FIXTURE_TEARDOWN TEST_F TEST_HARNESS_MAIN
> +                FIXTURE_TEARDOWN TEST_F TEST_HARNESS_MAIN FIXTURE_PARAMS
> +                FIXTURE_PARAMS_ADD
>  
>  Operators
>  ---------
> diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
> index 7a3392941a5b..78b963f75d3b 100644
> --- a/tools/testing/selftests/kselftest_harness.h
> +++ b/tools/testing/selftests/kselftest_harness.h
> @@ -168,9 +168,15 @@
>  
>  #define __TEST_IMPL(test_name, _signal) \
>  	static void test_name(struct __test_metadata *_metadata); \
> +	static inline void wrapper_##test_name( \
> +		struct __test_metadata *_metadata, \
> +		struct __fixture_params_metadata *p) \
> +	{ \
> +		test_name(_metadata); \
> +	} \
>  	static struct __test_metadata _##test_name##_object = \
>  		{ .name = #test_name, \
> -		  .fn = &test_name, \
> +		  .fn = &wrapper_##test_name, \
>  		  .fixture = &_fixture_global, \
>  		  .termsig = _signal, \
>  		  .timeout = TEST_TIMEOUT_DEFAULT, }; \
> @@ -214,6 +220,7 @@
>   * populated and cleaned up using FIXTURE_SETUP() and FIXTURE_TEARDOWN().
>   */
>  #define FIXTURE(fixture_name) \
> +	FIXTURE_PARAMS(fixture_name); \
>  	static struct __fixture_metadata _##fixture_name##_fixture_object = \
>  		{ .name =  #fixture_name, }; \
>  	static void __attribute__((constructor)) \
> @@ -245,7 +252,9 @@
>  #define FIXTURE_SETUP(fixture_name) \
>  	void fixture_name##_setup( \
>  		struct __test_metadata __attribute__((unused)) *_metadata, \
> -		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self)
> +		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self, \
> +		const FIXTURE_PARAMS(fixture_name) __attribute__((unused)) *params)
> +
>  /**
>   * FIXTURE_TEARDOWN(fixture_name)
>   * *_metadata* is included so that EXPECT_* and ASSERT_* work correctly.
> @@ -267,6 +276,56 @@
>  		struct __test_metadata __attribute__((unused)) *_metadata, \
>  		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self)
>  
> +/**
> + * FIXTURE_PARAMS(fixture_name) - Optionally called once per fixture
> + * to declare fixture parameters
> + *
> + * @fixture_name: fixture name
> + *
> + * .. code-block:: c
> + *
> + *     FIXTURE_PARAMS(datatype name) {
> + *       type property1;
> + *       ...
> + *     };
> + *
> + * Defines type of constant parameters provided to FIXTURE_SETUP() and TEST_F()
> + * as *params*.
> + */
> +#define FIXTURE_PARAMS(fixture_name) struct _fixture_params_##fixture_name
> +
> +/**
> + * FIXTURE_PARAMS_ADD(fixture_name, params_name) - Called once per fixture
> + * params to setup the data and register
> + *
> + * @fixture_name: fixture name
> + * @params_name: name of the parameter set
> + *
> + * .. code-block:: c
> + *
> + *     FIXTURE_ADD(datatype name) {
> + *       .property1 = val1;
> + *       ...
> + *     };
> + *
> + * Defines an instance of parameters provided to FIXTURE_SETUP() and TEST_F()
> + * as *params*. Tests of each fixture will be run for each parameter set.
> + */
> +#define FIXTURE_PARAMS_ADD(fixture_name, params_name) \
> +	extern FIXTURE_PARAMS(fixture_name) \
> +		_##fixture_name##_##params_name##_params; \
> +	static struct __fixture_params_metadata \
> +		_##fixture_name##_##params_name##_object = \
> +		{ .name = #params_name, \
> +		  .data = &_##fixture_name##_##params_name##_params}; \
> +	static void __attribute__((constructor)) \
> +		_register_##fixture_name##_##params_name(void) \
> +	{ \
> +		__register_fixture_params(&_##fixture_name##_fixture_object, \
> +			&_##fixture_name##_##params_name##_object);	\
> +	} \
> +	FIXTURE_PARAMS(fixture_name) _##fixture_name##_##params_name##_params =
> +
>  /**
>   * TEST_F(fixture_name, test_name) - Emits test registration and helpers for
>   * fixture-based test cases
> @@ -297,18 +356,20 @@
>  #define __TEST_F_IMPL(fixture_name, test_name, signal, tmout) \
>  	static void fixture_name##_##test_name( \
>  		struct __test_metadata *_metadata, \
> -		FIXTURE_DATA(fixture_name) *self); \
> +		FIXTURE_DATA(fixture_name) *self, \
> +		const FIXTURE_PARAMS(fixture_name) *params); \
>  	static inline void wrapper_##fixture_name##_##test_name( \
> -		struct __test_metadata *_metadata) \
> +		struct __test_metadata *_metadata, \
> +		struct __fixture_params_metadata *p) \
>  	{ \
>  		/* fixture data is alloced, setup, and torn down per call. */ \
>  		FIXTURE_DATA(fixture_name) self; \
>  		memset(&self, 0, sizeof(FIXTURE_DATA(fixture_name))); \
> -		fixture_name##_setup(_metadata, &self); \
> +		fixture_name##_setup(_metadata, &self, p->data); \
>  		/* Let setup failure terminate early. */ \
>  		if (!_metadata->passed) \
>  			return; \
> -		fixture_name##_##test_name(_metadata, &self); \
> +		fixture_name##_##test_name(_metadata, &self, p->data); \
>  		fixture_name##_teardown(_metadata, &self); \
>  	} \
>  	static struct __test_metadata \
> @@ -326,7 +387,8 @@
>  	} \
>  	static void fixture_name##_##test_name( \
>  		struct __test_metadata __attribute__((unused)) *_metadata, \
> -		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self)
> +		FIXTURE_DATA(fixture_name) __attribute__((unused)) *self, \
> +		const FIXTURE_PARAMS(fixture_name) __attribute__((unused)) *params)

Could this be done without expanding the function arguments? (i.e. can
the params just stay attached to the __test_metadata, perhaps having the
test runner adjust a new "current_param" variable to point to the
current param? Having everything attached to the single __test_metadata
makes a lot of things easier, IMO.

-Kees

>  
>  /**
>   * TEST_HARNESS_MAIN - Simple wrapper to run the test harness
> @@ -638,10 +700,12 @@
>  
>  /* Contains all the information about a fixture */
>  struct __test_metadata;
> +struct __fixture_params_metadata;
>  
>  struct __fixture_metadata {
>  	const char *name;
>  	struct __test_metadata *tests;
> +	struct __fixture_params_metadata *params;
>  	struct __fixture_metadata *prev, *next;
>  } _fixture_global __attribute__((unused)) = {
>  	.name = "global",
> @@ -649,7 +713,6 @@ struct __fixture_metadata {
>  };
>  
>  static struct __fixture_metadata *__fixture_list = &_fixture_global;
> -static unsigned int __fixture_count;
>  static int __constructor_order;
>  
>  #define _CONSTRUCTOR_ORDER_FORWARD   1
> @@ -657,7 +720,6 @@ static int __constructor_order;
>  
>  static inline void __register_fixture(struct __fixture_metadata *f)
>  {
> -	__fixture_count++;
>  	/* Circular linked list where only prev is circular. */
>  	if (__constructor_order == _CONSTRUCTOR_ORDER_FORWARD) {
>  		f->next = NULL;
> @@ -672,10 +734,41 @@ static inline void __register_fixture(struct __fixture_metadata *f)
>  	}
>  }
>  
> +struct __fixture_params_metadata {
> +	const char *name;
> +	const void *data;
> +	struct __fixture_params_metadata *prev, *next;
> +};
> +
> +static inline void
> +__register_fixture_params(struct __fixture_metadata *f,
> +			  struct __fixture_params_metadata *p)
> +{
> +	/* Circular linked list where only prev is circular. */
> +	if (f->params == NULL) {
> +		f->params = p;
> +		p->next = NULL;
> +		p->prev = p;
> +		return;
> +	}
> +	if (__constructor_order == _CONSTRUCTOR_ORDER_FORWARD) {
> +		p->next = NULL;
> +		p->prev = f->params->prev;
> +		p->prev->next = p;
> +		f->params->prev = p;
> +	} else {
> +		p->next = f->params;
> +		p->next->prev = p;
> +		p->prev = p;
> +		f->params = p;
> +	}
> +}
> +
>  /* Contains all the information for test execution and status checking. */
>  struct __test_metadata {
>  	const char *name;
> -	void (*fn)(struct __test_metadata *);
> +	void (*fn)(struct __test_metadata *,
> +		   struct __fixture_params_metadata *);
>  	struct __fixture_metadata *fixture;
>  	int termsig;
>  	int passed;
> @@ -686,9 +779,6 @@ struct __test_metadata {
>  	struct __test_metadata *prev, *next;
>  };
>  
> -/* Storage for the (global) tests to be run. */
> -static unsigned int __test_count;
> -
>  /*
>   * Since constructors are called in reverse order, reverse the test
>   * list so tests are run in source declaration order.
> @@ -702,7 +792,6 @@ static inline void __register_test(struct __test_metadata *t)
>  {
>  	struct __fixture_metadata *f = t->fixture;
>  
> -	__test_count++;
>  	/* Circular linked list where only prev is circular. */
>  	if (f->tests == NULL) {
>  		f->tests = t;
> @@ -734,21 +823,26 @@ static inline int __bail(int for_realz, bool no_print, __u8 step)
>  }
>  
>  void __run_test(struct __fixture_metadata *f,
> +		struct __fixture_params_metadata *p,
>  		struct __test_metadata *t)
>  {
>  	pid_t child_pid;
>  	int status;
>  
> +	/* reset test struct */
>  	t->passed = 1;
>  	t->trigger = 0;
> -	printf("[ RUN      ] %s.%s\n", f->name, t->name);
> +	t->step = 0;
> +	t->no_print = 0;
> +
> +	printf("[ RUN      ] %s%s.%s\n", f->name, p->name, t->name);
>  	alarm(t->timeout);
>  	child_pid = fork();
>  	if (child_pid < 0) {
>  		printf("ERROR SPAWNING TEST CHILD\n");
>  		t->passed = 0;
>  	} else if (child_pid == 0) {
> -		t->fn(t);
> +		t->fn(t, p);
>  		/* return the step that failed or 0 */
>  		_exit(t->passed ? 0 : t->step);
>  	} else {
> @@ -790,31 +884,44 @@ void __run_test(struct __fixture_metadata *f,
>  				status);
>  		}
>  	}
> -	printf("[     %4s ] %s.%s\n", (t->passed ? "OK" : "FAIL"),
> -	       f->name, t->name);
> +	printf("[     %4s ] %s%s.%s\n", (t->passed ? "OK" : "FAIL"),
> +	       f->name, p->name, t->name);
>  	alarm(0);
>  }
>  
>  static int test_harness_run(int __attribute__((unused)) argc,
>  			    char __attribute__((unused)) **argv)
>  {
> +	struct __fixture_params_metadata no_param = { .name = "", };
> +	struct __fixture_params_metadata *p;
>  	struct __fixture_metadata *f;
>  	struct __test_metadata *t;
>  	int ret = 0;
> +	unsigned int fixture_count = 0, test_count = 0;
>  	unsigned int count = 0;
>  	unsigned int pass_count = 0;
>  
> +	for (f = __fixture_list; f; f = f->next) {
> +		fixture_count++;
> +		for (p = f->params ?: &no_param; p; p = p->next) {
> +			for (t = f->tests; t; t = t->next)
> +				test_count++;
> +		}
> +	}
> +
>  	/* TODO(wad) add optional arguments similar to gtest. */
>  	printf("[==========] Running %u tests from %u test cases.\n",
> -	       __test_count, __fixture_count + 1);
> +	       test_count, fixture_count);
>  	for (f = __fixture_list; f; f = f->next) {
> -		for (t = f->tests; t; t = t->next) {
> -			count++;
> -			__run_test(f, t);
> -			if (t->passed)
> -				pass_count++;
> -			else
> -				ret = 1;
> +		for (p = f->params ?: &no_param; p; p = p->next) {
> +			for (t = f->tests; t; t = t->next) {
> +				count++;
> +				__run_test(f, p, t);
> +				if (t->passed)
> +					pass_count++;
> +				else
> +					ret = 1;
> +			}
>  		}
>  	}
>  	printf("[==========] %u / %u tests passed.\n", pass_count, count);
> -- 
> 2.24.1
> 

-- 
Kees Cook
