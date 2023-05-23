Return-Path: <netdev+bounces-4774-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E11E70E2B0
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 19:19:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECEA01C20D49
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCAEE20992;
	Tue, 23 May 2023 17:19:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADA84C91
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 17:19:29 +0000 (UTC)
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540B8C2
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:19:25 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-510d9218506so189540a12.1
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google; t=1684862363; x=1687454363;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tQVAbVuu2pa2bcJsR1XMdWMGn8VlAhJr++/e+T0GLiQ=;
        b=Wzq64VQn81ISBLQQrAKWZXpedsghUgeidzXFT0txglxDpRNryxIrmanP0L0rruDHFi
         4EMyoXEQz5r7M/dXLf+uDrR9jjU0wJyinladnhyIo/dYKV+OLYV146CozxTwup0/gtpO
         6IhGdjmzzTxhi17RrfYpNwfXUGWkW/gmRFRG0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684862363; x=1687454363;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tQVAbVuu2pa2bcJsR1XMdWMGn8VlAhJr++/e+T0GLiQ=;
        b=Kt1EGVLX7DVPLlLReZ4UpRcY/4IvfiQJQ0pBqrVvJKLp2gARwPAWdAUn37Yr/F9q/m
         JmlVPF47o6LLcgFZ+NZhv03e6yTyiFgINDQ+HxKlpOyztVb+iYUtXNccHK6o8ik8r2OA
         P1GEEjFyWpmce6GHiaG/zlP46/ULDPJd5kegYagZEPdBHN8Tw7IMEnB9+daH91194DDm
         wRV2hwrJQMK6yM0vh7AumfNTus4to+B/eegUmwe16XTfOzwp3GE/ylXoBrWRhn3b67cL
         iwZC8YaQq5SAfbDC/gIDeA7lkR68gjMWxeY1zyM6ZIkeoTcbg1fvOqwxWzCORFeWMTHe
         DLzw==
X-Gm-Message-State: AC+VfDwH61VoFOOEwseBcSbI3vb+ywXoj03rZB7lk16YHvju6cZc4c38
	SKARwu5XhX2I7R8qfw+nO9VBEXZf0gcg3+QjGpNl8w==
X-Google-Smtp-Source: ACHHUZ6H9nXLAI/WmXHD3NwGUpC2q+z9mHH90z+6KE/Ij2v/5hxGGJmA44HVHXme2YPQxXbj1Y7e5A==
X-Received: by 2002:a05:6402:1e90:b0:506:72f8:eb10 with SMTP id f16-20020a0564021e9000b0050672f8eb10mr21537045edf.0.1684862363216;
        Tue, 23 May 2023 10:19:23 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-79-24-92-214.retail.telecomitalia.it. [79.24.92.214])
        by smtp.gmail.com with ESMTPSA id i14-20020a50fc0e000000b00510e7914af5sm4288411edr.77.2023.05.23.10.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 10:19:22 -0700 (PDT)
From: Dario Binacchi <dario.binacchi@amarulasolutions.com>
To: netdev@vger.kernel.org
Cc: Michal Kubecek <mkubecek@suse.cz>,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>
Subject: [PATCH ethtool] Require a compiler with support for C++11 features
Date: Tue, 23 May 2023 19:19:08 +0200
Message-Id: <20230523171908.2000901-1-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Just like the kernel, which has been using -std=gnu11 for about a year,
we also require a C11 compiler for ethtool.

The addition of m4 macros allows the package to be compiled even if they
are not present in the autoconf-archive.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
---
 configure.ac                   |    3 +
 m4/ax_cxx_compile_stdcxx.m4    | 1009 ++++++++++++++++++++++++++++++++
 m4/ax_cxx_compile_stdcxx_11.m4 |   39 ++
 3 files changed, 1051 insertions(+)
 create mode 100644 m4/ax_cxx_compile_stdcxx.m4
 create mode 100644 m4/ax_cxx_compile_stdcxx_11.m4

diff --git a/configure.ac b/configure.ac
index c1e001247138..133749468bde 100644
--- a/configure.ac
+++ b/configure.ac
@@ -4,6 +4,7 @@ AC_PREREQ(2.52)
 AC_CONFIG_SRCDIR([ethtool.c])
 AM_INIT_AUTOMAKE([gnu subdir-objects])
 AC_CONFIG_HEADERS([ethtool-config.h])
+AC_CONFIG_MACRO_DIR([m4])
 
 AM_MAINTAINER_MODE
 
@@ -13,6 +14,8 @@ AC_PROG_GCC_TRADITIONAL
 AM_PROG_CC_C_O
 PKG_PROG_PKG_CONFIG
 
+AX_CXX_COMPILE_STDCXX_11(,[mandatory])
+
 dnl Checks for libraries.
 
 dnl Checks for header files.
diff --git a/m4/ax_cxx_compile_stdcxx.m4 b/m4/ax_cxx_compile_stdcxx.m4
new file mode 100644
index 000000000000..a3d964c699aa
--- /dev/null
+++ b/m4/ax_cxx_compile_stdcxx.m4
@@ -0,0 +1,1009 @@
+# ===========================================================================
+#  https://www.gnu.org/software/autoconf-archive/ax_cxx_compile_stdcxx.html
+# ===========================================================================
+#
+# SYNOPSIS
+#
+#   AX_CXX_COMPILE_STDCXX(VERSION, [ext|noext], [mandatory|optional])
+#
+# DESCRIPTION
+#
+#   Check for baseline language coverage in the compiler for the specified
+#   version of the C++ standard.  If necessary, add switches to CXX and
+#   CXXCPP to enable support.  VERSION may be '11', '14', '17', or '20' for
+#   the respective C++ standard version.
+#
+#   The second argument, if specified, indicates whether you insist on an
+#   extended mode (e.g. -std=gnu++11) or a strict conformance mode (e.g.
+#   -std=c++11).  If neither is specified, you get whatever works, with
+#   preference for no added switch, and then for an extended mode.
+#
+#   The third argument, if specified 'mandatory' or if left unspecified,
+#   indicates that baseline support for the specified C++ standard is
+#   required and that the macro should error out if no mode with that
+#   support is found.  If specified 'optional', then configuration proceeds
+#   regardless, after defining HAVE_CXX${VERSION} if and only if a
+#   supporting mode is found.
+#
+# LICENSE
+#
+#   Copyright (c) 2008 Benjamin Kosnik <bkoz@redhat.com>
+#   Copyright (c) 2012 Zack Weinberg <zackw@panix.com>
+#   Copyright (c) 2013 Roy Stogner <roystgnr@ices.utexas.edu>
+#   Copyright (c) 2014, 2015 Google Inc.; contributed by Alexey Sokolov <sokolov@google.com>
+#   Copyright (c) 2015 Paul Norman <penorman@mac.com>
+#   Copyright (c) 2015 Moritz Klammler <moritz@klammler.eu>
+#   Copyright (c) 2016, 2018 Krzesimir Nowak <qdlacz@gmail.com>
+#   Copyright (c) 2019 Enji Cooper <yaneurabeya@gmail.com>
+#   Copyright (c) 2020 Jason Merrill <jason@redhat.com>
+#   Copyright (c) 2021 Jörn Heusipp <osmanx@problemloesungsmaschine.de>
+#
+#   Copying and distribution of this file, with or without modification, are
+#   permitted in any medium without royalty provided the copyright notice
+#   and this notice are preserved.  This file is offered as-is, without any
+#   warranty.
+
+#serial 15
+
+dnl  This macro is based on the code from the AX_CXX_COMPILE_STDCXX_11 macro
+dnl  (serial version number 13).
+
+AC_DEFUN([AX_CXX_COMPILE_STDCXX], [dnl
+  m4_if([$1], [11], [ax_cxx_compile_alternatives="11 0x"],
+        [$1], [14], [ax_cxx_compile_alternatives="14 1y"],
+        [$1], [17], [ax_cxx_compile_alternatives="17 1z"],
+        [$1], [20], [ax_cxx_compile_alternatives="20"],
+        [m4_fatal([invalid first argument `$1' to AX_CXX_COMPILE_STDCXX])])dnl
+  m4_if([$2], [], [],
+        [$2], [ext], [],
+        [$2], [noext], [],
+        [m4_fatal([invalid second argument `$2' to AX_CXX_COMPILE_STDCXX])])dnl
+  m4_if([$3], [], [ax_cxx_compile_cxx$1_required=true],
+        [$3], [mandatory], [ax_cxx_compile_cxx$1_required=true],
+        [$3], [optional], [ax_cxx_compile_cxx$1_required=false],
+        [m4_fatal([invalid third argument `$3' to AX_CXX_COMPILE_STDCXX])])
+  AC_LANG_PUSH([C++])dnl
+  ac_success=no
+
+  m4_if([$2], [], [dnl
+    AC_CACHE_CHECK(whether $CXX supports C++$1 features by default,
+		   ax_cv_cxx_compile_cxx$1,
+      [AC_COMPILE_IFELSE([AC_LANG_SOURCE([_AX_CXX_COMPILE_STDCXX_testbody_$1])],
+        [ax_cv_cxx_compile_cxx$1=yes],
+        [ax_cv_cxx_compile_cxx$1=no])])
+    if test x$ax_cv_cxx_compile_cxx$1 = xyes; then
+      ac_success=yes
+    fi])
+
+  m4_if([$2], [noext], [], [dnl
+  if test x$ac_success = xno; then
+    for alternative in ${ax_cxx_compile_alternatives}; do
+      switch="-std=gnu++${alternative}"
+      cachevar=AS_TR_SH([ax_cv_cxx_compile_cxx$1_$switch])
+      AC_CACHE_CHECK(whether $CXX supports C++$1 features with $switch,
+                     $cachevar,
+        [ac_save_CXX="$CXX"
+         CXX="$CXX $switch"
+         AC_COMPILE_IFELSE([AC_LANG_SOURCE([_AX_CXX_COMPILE_STDCXX_testbody_$1])],
+          [eval $cachevar=yes],
+          [eval $cachevar=no])
+         CXX="$ac_save_CXX"])
+      if eval test x\$$cachevar = xyes; then
+        CXX="$CXX $switch"
+        if test -n "$CXXCPP" ; then
+          CXXCPP="$CXXCPP $switch"
+        fi
+        ac_success=yes
+        break
+      fi
+    done
+  fi])
+
+  m4_if([$2], [ext], [], [dnl
+  if test x$ac_success = xno; then
+    dnl HP's aCC needs +std=c++11 according to:
+    dnl http://h21007.www2.hp.com/portal/download/files/unprot/aCxx/PDF_Release_Notes/769149-001.pdf
+    dnl Cray's crayCC needs "-h std=c++11"
+    for alternative in ${ax_cxx_compile_alternatives}; do
+      for switch in -std=c++${alternative} +std=c++${alternative} "-h std=c++${alternative}"; do
+        cachevar=AS_TR_SH([ax_cv_cxx_compile_cxx$1_$switch])
+        AC_CACHE_CHECK(whether $CXX supports C++$1 features with $switch,
+                       $cachevar,
+          [ac_save_CXX="$CXX"
+           CXX="$CXX $switch"
+           AC_COMPILE_IFELSE([AC_LANG_SOURCE([_AX_CXX_COMPILE_STDCXX_testbody_$1])],
+            [eval $cachevar=yes],
+            [eval $cachevar=no])
+           CXX="$ac_save_CXX"])
+        if eval test x\$$cachevar = xyes; then
+          CXX="$CXX $switch"
+          if test -n "$CXXCPP" ; then
+            CXXCPP="$CXXCPP $switch"
+          fi
+          ac_success=yes
+          break
+        fi
+      done
+      if test x$ac_success = xyes; then
+        break
+      fi
+    done
+  fi])
+  AC_LANG_POP([C++])
+  if test x$ax_cxx_compile_cxx$1_required = xtrue; then
+    if test x$ac_success = xno; then
+      AC_MSG_ERROR([*** A compiler with support for C++$1 language features is required.])
+    fi
+  fi
+  if test x$ac_success = xno; then
+    HAVE_CXX$1=0
+    AC_MSG_NOTICE([No compiler with C++$1 support was found])
+  else
+    HAVE_CXX$1=1
+    AC_DEFINE(HAVE_CXX$1,1,
+              [define if the compiler supports basic C++$1 syntax])
+  fi
+  AC_SUBST(HAVE_CXX$1)
+])
+
+
+dnl  Test body for checking C++11 support
+
+m4_define([_AX_CXX_COMPILE_STDCXX_testbody_11],
+  _AX_CXX_COMPILE_STDCXX_testbody_new_in_11
+)
+
+dnl  Test body for checking C++14 support
+
+m4_define([_AX_CXX_COMPILE_STDCXX_testbody_14],
+  _AX_CXX_COMPILE_STDCXX_testbody_new_in_11
+  _AX_CXX_COMPILE_STDCXX_testbody_new_in_14
+)
+
+dnl  Test body for checking C++17 support
+
+m4_define([_AX_CXX_COMPILE_STDCXX_testbody_17],
+  _AX_CXX_COMPILE_STDCXX_testbody_new_in_11
+  _AX_CXX_COMPILE_STDCXX_testbody_new_in_14
+  _AX_CXX_COMPILE_STDCXX_testbody_new_in_17
+)
+
+dnl  Test body for checking C++20 support
+
+m4_define([_AX_CXX_COMPILE_STDCXX_testbody_20],
+  _AX_CXX_COMPILE_STDCXX_testbody_new_in_11
+  _AX_CXX_COMPILE_STDCXX_testbody_new_in_14
+  _AX_CXX_COMPILE_STDCXX_testbody_new_in_17
+  _AX_CXX_COMPILE_STDCXX_testbody_new_in_20
+)
+
+
+dnl  Tests for new features in C++11
+
+m4_define([_AX_CXX_COMPILE_STDCXX_testbody_new_in_11], [[
+
+// If the compiler admits that it is not ready for C++11, why torture it?
+// Hopefully, this will speed up the test.
+
+#ifndef __cplusplus
+
+#error "This is not a C++ compiler"
+
+// MSVC always sets __cplusplus to 199711L in older versions; newer versions
+// only set it correctly if /Zc:__cplusplus is specified as well as a
+// /std:c++NN switch:
+// https://devblogs.microsoft.com/cppblog/msvc-now-correctly-reports-__cplusplus/
+#elif __cplusplus < 201103L && !defined _MSC_VER
+
+#error "This is not a C++11 compiler"
+
+#else
+
+namespace cxx11
+{
+
+  namespace test_static_assert
+  {
+
+    template <typename T>
+    struct check
+    {
+      static_assert(sizeof(int) <= sizeof(T), "not big enough");
+    };
+
+  }
+
+  namespace test_final_override
+  {
+
+    struct Base
+    {
+      virtual ~Base() {}
+      virtual void f() {}
+    };
+
+    struct Derived : public Base
+    {
+      virtual ~Derived() override {}
+      virtual void f() override {}
+    };
+
+  }
+
+  namespace test_double_right_angle_brackets
+  {
+
+    template < typename T >
+    struct check {};
+
+    typedef check<void> single_type;
+    typedef check<check<void>> double_type;
+    typedef check<check<check<void>>> triple_type;
+    typedef check<check<check<check<void>>>> quadruple_type;
+
+  }
+
+  namespace test_decltype
+  {
+
+    int
+    f()
+    {
+      int a = 1;
+      decltype(a) b = 2;
+      return a + b;
+    }
+
+  }
+
+  namespace test_type_deduction
+  {
+
+    template < typename T1, typename T2 >
+    struct is_same
+    {
+      static const bool value = false;
+    };
+
+    template < typename T >
+    struct is_same<T, T>
+    {
+      static const bool value = true;
+    };
+
+    template < typename T1, typename T2 >
+    auto
+    add(T1 a1, T2 a2) -> decltype(a1 + a2)
+    {
+      return a1 + a2;
+    }
+
+    int
+    test(const int c, volatile int v)
+    {
+      static_assert(is_same<int, decltype(0)>::value == true, "");
+      static_assert(is_same<int, decltype(c)>::value == false, "");
+      static_assert(is_same<int, decltype(v)>::value == false, "");
+      auto ac = c;
+      auto av = v;
+      auto sumi = ac + av + 'x';
+      auto sumf = ac + av + 1.0;
+      static_assert(is_same<int, decltype(ac)>::value == true, "");
+      static_assert(is_same<int, decltype(av)>::value == true, "");
+      static_assert(is_same<int, decltype(sumi)>::value == true, "");
+      static_assert(is_same<int, decltype(sumf)>::value == false, "");
+      static_assert(is_same<int, decltype(add(c, v))>::value == true, "");
+      return (sumf > 0.0) ? sumi : add(c, v);
+    }
+
+  }
+
+  namespace test_noexcept
+  {
+
+    int f() { return 0; }
+    int g() noexcept { return 0; }
+
+    static_assert(noexcept(f()) == false, "");
+    static_assert(noexcept(g()) == true, "");
+
+  }
+
+  namespace test_constexpr
+  {
+
+    template < typename CharT >
+    unsigned long constexpr
+    strlen_c_r(const CharT *const s, const unsigned long acc) noexcept
+    {
+      return *s ? strlen_c_r(s + 1, acc + 1) : acc;
+    }
+
+    template < typename CharT >
+    unsigned long constexpr
+    strlen_c(const CharT *const s) noexcept
+    {
+      return strlen_c_r(s, 0UL);
+    }
+
+    static_assert(strlen_c("") == 0UL, "");
+    static_assert(strlen_c("1") == 1UL, "");
+    static_assert(strlen_c("example") == 7UL, "");
+    static_assert(strlen_c("another\0example") == 7UL, "");
+
+  }
+
+  namespace test_rvalue_references
+  {
+
+    template < int N >
+    struct answer
+    {
+      static constexpr int value = N;
+    };
+
+    answer<1> f(int&)       { return answer<1>(); }
+    answer<2> f(const int&) { return answer<2>(); }
+    answer<3> f(int&&)      { return answer<3>(); }
+
+    void
+    test()
+    {
+      int i = 0;
+      const int c = 0;
+      static_assert(decltype(f(i))::value == 1, "");
+      static_assert(decltype(f(c))::value == 2, "");
+      static_assert(decltype(f(0))::value == 3, "");
+    }
+
+  }
+
+  namespace test_uniform_initialization
+  {
+
+    struct test
+    {
+      static const int zero {};
+      static const int one {1};
+    };
+
+    static_assert(test::zero == 0, "");
+    static_assert(test::one == 1, "");
+
+  }
+
+  namespace test_lambdas
+  {
+
+    void
+    test1()
+    {
+      auto lambda1 = [](){};
+      auto lambda2 = lambda1;
+      lambda1();
+      lambda2();
+    }
+
+    int
+    test2()
+    {
+      auto a = [](int i, int j){ return i + j; }(1, 2);
+      auto b = []() -> int { return '0'; }();
+      auto c = [=](){ return a + b; }();
+      auto d = [&](){ return c; }();
+      auto e = [a, &b](int x) mutable {
+        const auto identity = [](int y){ return y; };
+        for (auto i = 0; i < a; ++i)
+          a += b--;
+        return x + identity(a + b);
+      }(0);
+      return a + b + c + d + e;
+    }
+
+    int
+    test3()
+    {
+      const auto nullary = [](){ return 0; };
+      const auto unary = [](int x){ return x; };
+      using nullary_t = decltype(nullary);
+      using unary_t = decltype(unary);
+      const auto higher1st = [](nullary_t f){ return f(); };
+      const auto higher2nd = [unary](nullary_t f1){
+        return [unary, f1](unary_t f2){ return f2(unary(f1())); };
+      };
+      return higher1st(nullary) + higher2nd(nullary)(unary);
+    }
+
+  }
+
+  namespace test_variadic_templates
+  {
+
+    template <int...>
+    struct sum;
+
+    template <int N0, int... N1toN>
+    struct sum<N0, N1toN...>
+    {
+      static constexpr auto value = N0 + sum<N1toN...>::value;
+    };
+
+    template <>
+    struct sum<>
+    {
+      static constexpr auto value = 0;
+    };
+
+    static_assert(sum<>::value == 0, "");
+    static_assert(sum<1>::value == 1, "");
+    static_assert(sum<23>::value == 23, "");
+    static_assert(sum<1, 2>::value == 3, "");
+    static_assert(sum<5, 5, 11>::value == 21, "");
+    static_assert(sum<2, 3, 5, 7, 11, 13>::value == 41, "");
+
+  }
+
+  // http://stackoverflow.com/questions/13728184/template-aliases-and-sfinae
+  // Clang 3.1 fails with headers of libstd++ 4.8.3 when using std::function
+  // because of this.
+  namespace test_template_alias_sfinae
+  {
+
+    struct foo {};
+
+    template<typename T>
+    using member = typename T::member_type;
+
+    template<typename T>
+    void func(...) {}
+
+    template<typename T>
+    void func(member<T>*) {}
+
+    void test();
+
+    void test() { func<foo>(0); }
+
+  }
+
+}  // namespace cxx11
+
+#endif  // __cplusplus >= 201103L
+
+]])
+
+
+dnl  Tests for new features in C++14
+
+m4_define([_AX_CXX_COMPILE_STDCXX_testbody_new_in_14], [[
+
+// If the compiler admits that it is not ready for C++14, why torture it?
+// Hopefully, this will speed up the test.
+
+#ifndef __cplusplus
+
+#error "This is not a C++ compiler"
+
+#elif __cplusplus < 201402L && !defined _MSC_VER
+
+#error "This is not a C++14 compiler"
+
+#else
+
+namespace cxx14
+{
+
+  namespace test_polymorphic_lambdas
+  {
+
+    int
+    test()
+    {
+      const auto lambda = [](auto&&... args){
+        const auto istiny = [](auto x){
+          return (sizeof(x) == 1UL) ? 1 : 0;
+        };
+        const int aretiny[] = { istiny(args)... };
+        return aretiny[0];
+      };
+      return lambda(1, 1L, 1.0f, '1');
+    }
+
+  }
+
+  namespace test_binary_literals
+  {
+
+    constexpr auto ivii = 0b0000000000101010;
+    static_assert(ivii == 42, "wrong value");
+
+  }
+
+  namespace test_generalized_constexpr
+  {
+
+    template < typename CharT >
+    constexpr unsigned long
+    strlen_c(const CharT *const s) noexcept
+    {
+      auto length = 0UL;
+      for (auto p = s; *p; ++p)
+        ++length;
+      return length;
+    }
+
+    static_assert(strlen_c("") == 0UL, "");
+    static_assert(strlen_c("x") == 1UL, "");
+    static_assert(strlen_c("test") == 4UL, "");
+    static_assert(strlen_c("another\0test") == 7UL, "");
+
+  }
+
+  namespace test_lambda_init_capture
+  {
+
+    int
+    test()
+    {
+      auto x = 0;
+      const auto lambda1 = [a = x](int b){ return a + b; };
+      const auto lambda2 = [a = lambda1(x)](){ return a; };
+      return lambda2();
+    }
+
+  }
+
+  namespace test_digit_separators
+  {
+
+    constexpr auto ten_million = 100'000'000;
+    static_assert(ten_million == 100000000, "");
+
+  }
+
+  namespace test_return_type_deduction
+  {
+
+    auto f(int& x) { return x; }
+    decltype(auto) g(int& x) { return x; }
+
+    template < typename T1, typename T2 >
+    struct is_same
+    {
+      static constexpr auto value = false;
+    };
+
+    template < typename T >
+    struct is_same<T, T>
+    {
+      static constexpr auto value = true;
+    };
+
+    int
+    test()
+    {
+      auto x = 0;
+      static_assert(is_same<int, decltype(f(x))>::value, "");
+      static_assert(is_same<int&, decltype(g(x))>::value, "");
+      return x;
+    }
+
+  }
+
+}  // namespace cxx14
+
+#endif  // __cplusplus >= 201402L
+
+]])
+
+
+dnl  Tests for new features in C++17
+
+m4_define([_AX_CXX_COMPILE_STDCXX_testbody_new_in_17], [[
+
+// If the compiler admits that it is not ready for C++17, why torture it?
+// Hopefully, this will speed up the test.
+
+#ifndef __cplusplus
+
+#error "This is not a C++ compiler"
+
+#elif __cplusplus < 201703L && !defined _MSC_VER
+
+#error "This is not a C++17 compiler"
+
+#else
+
+#include <initializer_list>
+#include <utility>
+#include <type_traits>
+
+namespace cxx17
+{
+
+  namespace test_constexpr_lambdas
+  {
+
+    constexpr int foo = [](){return 42;}();
+
+  }
+
+  namespace test::nested_namespace::definitions
+  {
+
+  }
+
+  namespace test_fold_expression
+  {
+
+    template<typename... Args>
+    int multiply(Args... args)
+    {
+      return (args * ... * 1);
+    }
+
+    template<typename... Args>
+    bool all(Args... args)
+    {
+      return (args && ...);
+    }
+
+  }
+
+  namespace test_extended_static_assert
+  {
+
+    static_assert (true);
+
+  }
+
+  namespace test_auto_brace_init_list
+  {
+
+    auto foo = {5};
+    auto bar {5};
+
+    static_assert(std::is_same<std::initializer_list<int>, decltype(foo)>::value);
+    static_assert(std::is_same<int, decltype(bar)>::value);
+  }
+
+  namespace test_typename_in_template_template_parameter
+  {
+
+    template<template<typename> typename X> struct D;
+
+  }
+
+  namespace test_fallthrough_nodiscard_maybe_unused_attributes
+  {
+
+    int f1()
+    {
+      return 42;
+    }
+
+    [[nodiscard]] int f2()
+    {
+      [[maybe_unused]] auto unused = f1();
+
+      switch (f1())
+      {
+      case 17:
+        f1();
+        [[fallthrough]];
+      case 42:
+        f1();
+      }
+      return f1();
+    }
+
+  }
+
+  namespace test_extended_aggregate_initialization
+  {
+
+    struct base1
+    {
+      int b1, b2 = 42;
+    };
+
+    struct base2
+    {
+      base2() {
+        b3 = 42;
+      }
+      int b3;
+    };
+
+    struct derived : base1, base2
+    {
+        int d;
+    };
+
+    derived d1 {{1, 2}, {}, 4};  // full initialization
+    derived d2 {{}, {}, 4};      // value-initialized bases
+
+  }
+
+  namespace test_general_range_based_for_loop
+  {
+
+    struct iter
+    {
+      int i;
+
+      int& operator* ()
+      {
+        return i;
+      }
+
+      const int& operator* () const
+      {
+        return i;
+      }
+
+      iter& operator++()
+      {
+        ++i;
+        return *this;
+      }
+    };
+
+    struct sentinel
+    {
+      int i;
+    };
+
+    bool operator== (const iter& i, const sentinel& s)
+    {
+      return i.i == s.i;
+    }
+
+    bool operator!= (const iter& i, const sentinel& s)
+    {
+      return !(i == s);
+    }
+
+    struct range
+    {
+      iter begin() const
+      {
+        return {0};
+      }
+
+      sentinel end() const
+      {
+        return {5};
+      }
+    };
+
+    void f()
+    {
+      range r {};
+
+      for (auto i : r)
+      {
+        [[maybe_unused]] auto v = i;
+      }
+    }
+
+  }
+
+  namespace test_lambda_capture_asterisk_this_by_value
+  {
+
+    struct t
+    {
+      int i;
+      int foo()
+      {
+        return [*this]()
+        {
+          return i;
+        }();
+      }
+    };
+
+  }
+
+  namespace test_enum_class_construction
+  {
+
+    enum class byte : unsigned char
+    {};
+
+    byte foo {42};
+
+  }
+
+  namespace test_constexpr_if
+  {
+
+    template <bool cond>
+    int f ()
+    {
+      if constexpr(cond)
+      {
+        return 13;
+      }
+      else
+      {
+        return 42;
+      }
+    }
+
+  }
+
+  namespace test_selection_statement_with_initializer
+  {
+
+    int f()
+    {
+      return 13;
+    }
+
+    int f2()
+    {
+      if (auto i = f(); i > 0)
+      {
+        return 3;
+      }
+
+      switch (auto i = f(); i + 4)
+      {
+      case 17:
+        return 2;
+
+      default:
+        return 1;
+      }
+    }
+
+  }
+
+  namespace test_template_argument_deduction_for_class_templates
+  {
+
+    template <typename T1, typename T2>
+    struct pair
+    {
+      pair (T1 p1, T2 p2)
+        : m1 {p1},
+          m2 {p2}
+      {}
+
+      T1 m1;
+      T2 m2;
+    };
+
+    void f()
+    {
+      [[maybe_unused]] auto p = pair{13, 42u};
+    }
+
+  }
+
+  namespace test_non_type_auto_template_parameters
+  {
+
+    template <auto n>
+    struct B
+    {};
+
+    B<5> b1;
+    B<'a'> b2;
+
+  }
+
+  namespace test_structured_bindings
+  {
+
+    int arr[2] = { 1, 2 };
+    std::pair<int, int> pr = { 1, 2 };
+
+    auto f1() -> int(&)[2]
+    {
+      return arr;
+    }
+
+    auto f2() -> std::pair<int, int>&
+    {
+      return pr;
+    }
+
+    struct S
+    {
+      int x1 : 2;
+      volatile double y1;
+    };
+
+    S f3()
+    {
+      return {};
+    }
+
+    auto [ x1, y1 ] = f1();
+    auto& [ xr1, yr1 ] = f1();
+    auto [ x2, y2 ] = f2();
+    auto& [ xr2, yr2 ] = f2();
+    const auto [ x3, y3 ] = f3();
+
+  }
+
+  namespace test_exception_spec_type_system
+  {
+
+    struct Good {};
+    struct Bad {};
+
+    void g1() noexcept;
+    void g2();
+
+    template<typename T>
+    Bad
+    f(T*, T*);
+
+    template<typename T1, typename T2>
+    Good
+    f(T1*, T2*);
+
+    static_assert (std::is_same_v<Good, decltype(f(g1, g2))>);
+
+  }
+
+  namespace test_inline_variables
+  {
+
+    template<class T> void f(T)
+    {}
+
+    template<class T> inline T g(T)
+    {
+      return T{};
+    }
+
+    template<> inline void f<>(int)
+    {}
+
+    template<> int g<>(int)
+    {
+      return 5;
+    }
+
+  }
+
+}  // namespace cxx17
+
+#endif  // __cplusplus < 201703L && !defined _MSC_VER
+
+]])
+
+
+dnl  Tests for new features in C++20
+
+m4_define([_AX_CXX_COMPILE_STDCXX_testbody_new_in_20], [[
+
+#ifndef __cplusplus
+
+#error "This is not a C++ compiler"
+
+#elif __cplusplus < 202002L && !defined _MSC_VER
+
+#error "This is not a C++20 compiler"
+
+#else
+
+#include <version>
+
+namespace cxx20
+{
+
+// As C++20 supports feature test macros in the standard, there is no
+// immediate need to actually test for feature availability on the
+// Autoconf side.
+
+}  // namespace cxx20
+
+#endif  // __cplusplus < 202002L && !defined _MSC_VER
+
+]])
diff --git a/m4/ax_cxx_compile_stdcxx_11.m4 b/m4/ax_cxx_compile_stdcxx_11.m4
new file mode 100644
index 000000000000..1733fd85f959
--- /dev/null
+++ b/m4/ax_cxx_compile_stdcxx_11.m4
@@ -0,0 +1,39 @@
+# =============================================================================
+#  https://www.gnu.org/software/autoconf-archive/ax_cxx_compile_stdcxx_11.html
+# =============================================================================
+#
+# SYNOPSIS
+#
+#   AX_CXX_COMPILE_STDCXX_11([ext|noext], [mandatory|optional])
+#
+# DESCRIPTION
+#
+#   Check for baseline language coverage in the compiler for the C++11
+#   standard; if necessary, add switches to CXX and CXXCPP to enable
+#   support.
+#
+#   This macro is a convenience alias for calling the AX_CXX_COMPILE_STDCXX
+#   macro with the version set to C++11.  The two optional arguments are
+#   forwarded literally as the second and third argument respectively.
+#   Please see the documentation for the AX_CXX_COMPILE_STDCXX macro for
+#   more information.  If you want to use this macro, you also need to
+#   download the ax_cxx_compile_stdcxx.m4 file.
+#
+# LICENSE
+#
+#   Copyright (c) 2008 Benjamin Kosnik <bkoz@redhat.com>
+#   Copyright (c) 2012 Zack Weinberg <zackw@panix.com>
+#   Copyright (c) 2013 Roy Stogner <roystgnr@ices.utexas.edu>
+#   Copyright (c) 2014, 2015 Google Inc.; contributed by Alexey Sokolov <sokolov@google.com>
+#   Copyright (c) 2015 Paul Norman <penorman@mac.com>
+#   Copyright (c) 2015 Moritz Klammler <moritz@klammler.eu>
+#
+#   Copying and distribution of this file, with or without modification, are
+#   permitted in any medium without royalty provided the copyright notice
+#   and this notice are preserved. This file is offered as-is, without any
+#   warranty.
+
+#serial 18
+
+AX_REQUIRE_DEFINED([AX_CXX_COMPILE_STDCXX])
+AC_DEFUN([AX_CXX_COMPILE_STDCXX_11], [AX_CXX_COMPILE_STDCXX([11], [$1], [$2])])
-- 
2.32.0


