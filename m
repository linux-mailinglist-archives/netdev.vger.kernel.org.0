Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9C72D2EDE
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 18:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbfJJQto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 12:49:44 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43936 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfJJQto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 12:49:44 -0400
Received: by mail-lf1-f67.google.com with SMTP id u3so4906401lfl.10
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 09:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=s0fYI4mrc7j9HOvfGUo/mEhI2QMF8qgXCSTkC3vv1W4=;
        b=cj++K3DwJS8fcrZcTt0BOlhgyngwDB4xaFbpeFA9xn4Z0hh8EMuyDZnVUDkSMt6ghC
         DVmUO56eFtG02ZJVt5mXVqF3KR5xqzPKY4yn5526RPczQ6rZnAVv74MFDPVns9lcXzfM
         VxDLxG5218CFZiCpi/GJ/VpAS7XG8ukbTcY5M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=s0fYI4mrc7j9HOvfGUo/mEhI2QMF8qgXCSTkC3vv1W4=;
        b=cwXxZEgxFBb7SXYRApbis7uFOPtq1onUyxYIqC/CDpWc9PFVmsfDUNxzkQcHGrJgxk
         54liw4Fs9E2HgbMnhIZrogiCgTw79YKvhSBEz/6qTI+nG1rUGQY29Zu8bU1+B8fqzxlf
         40i9ip2GZhjzq3TEQ9md2ot6eMvim9Ck9pSD7SnvNZRxx/mDRiso4Fn7ceTd8AxFc434
         i03L0xN//iKf3j5IiForji0QPOncDTU1a2Kq31+hrP4YaQq1qdsC12iIHdqAo6Mk+HzL
         UdLeecnkpQhmcP3HmavseT0atgzW4Upt6Kd/0CqXy63GlAVvFDgzDNlz7wVl0jUUPWUM
         nXxw==
X-Gm-Message-State: APjAAAUJZI95K0McRD+rYx7KiJM1+tETXzZpfn9x5sfknjCtlJgDrmx9
        t7nsByk966zKybg/l+ZTcgfsPg==
X-Google-Smtp-Source: APXvYqx4PIqk55FHaTswOL2puRmYL/n1MyDS9lqS8ihrHBXKit+TNqDk/nJ5JkiurmcC0w8AEvBwvw==
X-Received: by 2002:ac2:4466:: with SMTP id y6mr6568076lfl.8.1570726180697;
        Thu, 10 Oct 2019 09:49:40 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id c69sm1433030ljf.32.2019.10.10.09.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 09:49:40 -0700 (PDT)
References: <20191009094312.15284-1-jakub@cloudflare.com> <20191009094312.15284-2-jakub@cloudflare.com> <20191009163341.GE2096@mini-arch> <87lfts25mq.fsf@cloudflare.com> <20191010163157.GF2096@mini-arch>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATH bpf-next 2/2] selftests/bpf: Check that flow dissector can be re-attached
In-reply-to: <20191010163157.GF2096@mini-arch>
Date:   Thu, 10 Oct 2019 18:49:38 +0200
Message-ID: <87k19c1r6l.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 06:31 PM CEST, Stanislav Fomichev wrote:
> On 10/10, Jakub Sitnicki wrote:
>> On Wed, Oct 09, 2019 at 06:33 PM CEST, Stanislav Fomichev wrote:
>> > On 10/09, Jakub Sitnicki wrote:

[...]

>> >> +/* Not used here. For CHECK macro sake only. */
>> >> +static int duration;
>> > nit: you can use CHECK_FAIL macro instead which doesn't require this.
>> >
>> > if (CHECK_FAIL(expr)) {
>> > 	printf("something bad has happened\n");
>> > 	return/goto;
>> > }
>> >
>> > It may be more verbose than doing CHECK() with its embedded error
>> > message, so I leave it up to you to decide on whether you want to switch
>> > to CHECK_FAIL or stick to CHECK.
>> >
>>
>> I wouldn't mind switching to CHECK_FAIL. It reads better than CHECK with
>> error message stuck in the if expression. (There is a side-issue with
>> printf(). Will explain at the end [*].)
>>
>> Another thing to consider is that with CHECK the message indicating a
>> failure ("<test>:FAIL:<lineno>") and the actual explanation message are
>> on the same line. This makes the error log easier to reason.
>>
>> I'm torn here, and considering another alternative to address at least
>> the readability issue:
>>
>> if (fail_expr) {
>>         CHECK(1, "action", "explanation");
>>         return;
>> }
> Can we use perror for the error reporting?
>
> if (CHECK(fail_expr)) {
> 	perror("failed to do something"); // will print errno as well
> }
>
> This should give all the info needed to grep for this message and debug
> the problem.
>
> Alternatively, we can copy/move log_err() from the cgroup_helpers.h,
> and use it in test_progs; it prints file:line:errno <msg>.

CHECK_FAIL + perror() works for me. I've been experimenting with
extracting a new macro-helper (patch below) but perhaps it's an
overkill.

[...]

>> [*] The printf() issue.
>>
>> I've noticed that stdio hijacking that test_progs runner applies doesn't
>> quite work. printf() seems to skip the FILE stream buffer and write
>> whole lines directly to stdout. This results in reordered messages on
>> output.
>>
>> Here's a distilled reproducer for what test_progs does:
>>
>> int main(void)
>> {
>> 	FILE *stream;
>> 	char *buf;
>> 	size_t cnt;
>>
>> 	stream = stdout;
>> 	stdout = open_memstream(&buf, &cnt);
>> 	if (!stdout)
>> 		error(1, errno, "open_memstream");
>>
>> 	printf("foo");
>> 	printf("bar\n");
>> 	printf("baz");
>> 	printf("qux\n");
>>
>> 	fflush(stdout);
>> 	fclose(stdout);
>>
>> 	buf[cnt] = '\0';
>> 	fprintf(stream, "<<%s>>", buf);
>> 	if (buf[cnt-1] != '\n')
>> 		fprintf(stream, "\n");
>>
>> 	free(buf);
>> 	return 0;
>> }
>>
>> On output we get:
>>
>> $ ./hijack_stdout
>> bar
>> qux
>> <<foobaz>>
>> $
> What glibc do you have? I don't see any issues with your reproducer
> on my setup:
>
> $ ./a.out
> <<foobar
> bazqux
>>>$
>
> $ ldd --version
> ldd (Debian GLIBC 2.28-10) 2.28
>

Interesting. I'm on the same version, different distro:

$ rpm -q glibc
glibc-2.28-33.fc29.x86_64
glibc-2.28-33.fc29.i686

I'll need to dig deeper. Thanks for keeping me honest here.

-Jakub

---8<---

From 66fd85cd3bbb36cf99c8b6cbbb161d3c0533263b Mon Sep 17 00:00:00 2001
From: Jakub Sitnicki <jakub@cloudflare.com>
Date: Thu, 10 Oct 2019 15:29:28 +0200
Subject: [PATCH net-next] selftests/bpf: test_progs: Extract a macro for
 logging failures

When selecting a macro-helper to use for logging a test failure we are
faced with a choice between the shortcomings of CHECK and CHECK_FAIL.

CHECK is intended to be used in conjunction with bpf_prog_test_run(). It
expects a program run duration to be passed to it as an implicit argument.

While CHECK_FAIL is more generic but compared to CHECK doesn't allow
logging a custom error message to explain the failure.

Introduce a new macro-helper - FAIL, that is lower-level than the above it
and it intended to be used just log the failure with an explanation for it.

Because FAIL does in part what CHECK and CHECK_FAIL do, we can reuse it in
these macros. One side-effect is a slight the change in the log format. We
always display the line number where a check has passed/failed.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/testing/selftests/bpf/test_progs.h | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index 0c48f64f732b..9e203ff71b78 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -92,15 +92,19 @@ struct ipv6_packet {
 } __packed;
 extern struct ipv6_packet pkt_v6;
 
+#define FAIL(tag, format...) ({						\
+	test__fail();							\
+	printf("%s:%d:FAIL:%s ", __func__, __LINE__, tag);		\
+	printf(format);							\
+})
+
 #define _CHECK(condition, tag, duration, format...) ({			\
 	int __ret = !!(condition);					\
 	if (__ret) {							\
-		test__fail();						\
-		printf("%s:FAIL:%s ", __func__, tag);			\
-		printf(format);						\
+		FAIL(tag, format);					\
 	} else {							\
-		printf("%s:PASS:%s %d nsec\n",				\
-		       __func__, tag, duration);			\
+		printf("%s:%d:PASS:%s %d nsec\n",			\
+		       __func__, __LINE__, tag, duration);		\
 	}								\
 	__ret;								\
 })
@@ -108,8 +112,7 @@ extern struct ipv6_packet pkt_v6;
 #define CHECK_FAIL(condition) ({					\
 	int __ret = !!(condition);					\
 	if (__ret) {							\
-		test__fail();						\
-		printf("%s:FAIL:%d\n", __func__, __LINE__);		\
+		FAIL("", #condition "\n");				\
 	}								\
 	__ret;								\
 })
-- 
2.20.1

