Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C97B647FC
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 16:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbfGJOQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 10:16:08 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38063 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727897AbfGJOQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 10:16:05 -0400
Received: by mail-pg1-f195.google.com with SMTP id z75so1335014pgz.5
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 07:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AmgXE8R5A1l8PFdEQCWW828K08NV6IQfuZCkIZHdV04=;
        b=yNmqZE9y/HCyaXknSDANClLo8m1KbCwJuyzu12fI2stRfDmpaP04RVzd7Iz+0WF0Xi
         r7069QIm19EswUkCqRmJuwKjqrNnb6OnfgKq5Sm5wqUkzCV3GXW4sA1HEmA9tVgnUITC
         FaT6jVRZdgMDq6D42Mq1aLAJYZLDgqcNsBy+E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AmgXE8R5A1l8PFdEQCWW828K08NV6IQfuZCkIZHdV04=;
        b=GzNitxtpjKdCZ0D4qzUHZpkadaGVoi5sHiqMQ97nP4xShuJZ5wQ5KvQVD8Z4MjT5k4
         bDtKqt1tNLprtYqN7xGD7JHzzochPgpRRkiH50LBEtw2AYVkjbvn54hOApAI2ix04l0l
         FWWcaIvuecMXq5v8ObuKJsju+Da3X+jBkxqxBIhMWaad1LajDA3GNfRyilNmZAskbOcO
         dNoO/y4LyyFZC4ppbi024Yvxn/WNqB1oYqDGPTats0Z3iBL7qC6+azt9jFRmyy5tPjni
         GxJBTC1LN1lAl5Jzm2lf/+Fut1mH/1WoZRrEi8nsiAGuxj7kKska3HZOspN+FlSTW60t
         sKjg==
X-Gm-Message-State: APjAAAXGoHVC//ugjuX/tmwd0dzqaDB9CfC7UVV7+zFa/THGrNg+MnUn
        43/AZouiSGAluaHHG7V1T6zAUQ==
X-Google-Smtp-Source: APXvYqzPoycqb2n3e29kQYZVL3KTErAQGB2rsrgdO0LYMSG9rIGtHDYdJHz7JfaDzIgu3l0p7Zh0zA==
X-Received: by 2002:a65:404d:: with SMTP id h13mr36664076pgp.71.1562768164742;
        Wed, 10 Jul 2019 07:16:04 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id l124sm2589249pgl.54.2019.07.10.07.16.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 07:16:04 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        Brendan Gregg <brendan.d.gregg@gmail.com>, connoro@google.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        duyuchao <yuchao.du@unisoc.com>, Ingo Molnar <mingo@redhat.com>,
        jeffv@google.com, Karim Yaghmour <karim.yaghmour@opersys.com>,
        kernel-team@android.com, linux-kselftest@vger.kernel.org,
        Manali Shukla <manalishukla14@gmail.com>,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Matt Mullins <mmullins@fb.com>,
        Michal Gregorczyk <michalgr@fb.com>,
        Michal Gregorczyk <michalgr@live.com>,
        Mohammad Husain <russoue@gmail.com>, namhyung@google.com,
        namhyung@kernel.org, netdev@vger.kernel.org,
        paul.chaignon@gmail.com, primiano@google.com,
        Qais Yousef <qais.yousef@arm.com>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Srinivas Ramana <sramana@codeaurora.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH RFC 2/4] trace/bpf: Add support for attach/detach of ftrace events to BPF
Date:   Wed, 10 Jul 2019 10:15:46 -0400
Message-Id: <20190710141548.132193-3-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190710141548.132193-1-joel@joelfernandes.org>
References: <20190710141548.132193-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new bpf file to each trace event. The following commands can be
written into it:
attach:<fd>	Attaches BPF prog fd to tracepoint
detach:<fd>	Detaches BPF prog fd to tracepoint

Reading the bpf file will show all the attached programs to the
tracepoint.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 include/linux/bpf_trace.h    |   6 ++
 include/linux/trace_events.h |   1 +
 kernel/trace/bpf_trace.c     | 169 +++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h         |   1 +
 kernel/trace/trace_events.c  |   9 +-
 5 files changed, 184 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf_trace.h b/include/linux/bpf_trace.h
index 4a593827fd87..1fe73501809c 100644
--- a/include/linux/bpf_trace.h
+++ b/include/linux/bpf_trace.h
@@ -9,6 +9,12 @@
 struct bpf_raw_tracepoint {
 	struct bpf_raw_event_map *btp;
 	struct bpf_prog *prog;
+	/*
+	 * Multiple programs can be attached to a tracepoint,
+	 * All of these are linked to each other and can be reached
+	 * from the event's bpf_attach file in tracefs.
+	 */
+	struct list_head event_attached;
 };
 
 struct bpf_raw_tracepoint *bpf_raw_tracepoint_open(char *tp_name, int prog_fd);
diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 8a62731673f7..525f2ac44aa3 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -371,6 +371,7 @@ struct trace_event_file {
 	struct trace_array		*tr;
 	struct trace_subsystem_dir	*system;
 	struct list_head		triggers;
+	struct list_head		bpf_attached;
 
 	/*
 	 * 32 bit flags:
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index c4b543bc617f..28621ad88c12 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1469,3 +1469,172 @@ struct bpf_raw_tracepoint *bpf_raw_tracepoint_open(char *tp_name, int prog_fd)
 	bpf_put_raw_tracepoint(btp);
 	return ERR_PTR(err);
 }
+
+enum event_bpf_cmd { BPF_ATTACH, BPF_DETACH };
+#define BPF_CMD_BUF_LEN 32
+
+static ssize_t
+event_bpf_attach_write(struct file *filp, const char __user *ubuf,
+		    size_t cnt, loff_t *ppos)
+{
+	int err, prog_fd, cmd_num, len;
+	struct trace_event_call *call;
+	struct trace_event_file *file;
+	struct bpf_raw_tracepoint *raw_tp, *next;
+	char buf[BPF_CMD_BUF_LEN], *end, *tok;
+	enum event_bpf_cmd cmd;
+	struct bpf_prog *prog;
+	bool prog_put = true;
+
+	len = min((int)cnt, BPF_CMD_BUF_LEN - 1);
+
+	err = copy_from_user(buf, ubuf, len);
+	if (err)
+		return err;
+	buf[len] = 0;
+
+	/* Parse 2 arguments of format: <cmd>:<fd> */
+	end = &buf[0];
+	cmd_num = 1;
+	while (cmd_num < 3) {
+		tok = strsep(&end, ":");
+		if (!tok)
+			return -EINVAL;
+
+		switch (cmd_num) {
+		case 1:
+			if (!strncmp(tok, "attach", 6))
+				cmd = BPF_ATTACH;
+			else if (!strncmp(tok, "detach", 6))
+				cmd = BPF_DETACH;
+			else
+				return -EINVAL;
+			break;
+		case 2:
+			err = kstrtoint(tok, 10, &prog_fd);
+			if (err)
+				return err;
+			break;
+		}
+		cmd_num++;
+	}
+	if (cmd_num != 3)
+		return -EINVAL;
+
+	file = event_file_data(filp);
+	/* Command is to attach fd to tracepoint */
+	if (cmd == BPF_ATTACH) {
+		mutex_lock(&event_mutex);
+		call = file->event_call;
+
+		raw_tp = bpf_raw_tracepoint_open((char *)call->tp->name,
+						 prog_fd);
+		if (IS_ERR(raw_tp)) {
+			mutex_unlock(&event_mutex);
+			return PTR_ERR(raw_tp);
+		}
+
+		list_add(&raw_tp->event_attached, &file->bpf_attached);
+		mutex_unlock(&event_mutex);
+		*ppos += cnt;
+		return cnt;
+	}
+
+	/* Command is to detach fd from tracepoint */
+	prog = bpf_prog_get(prog_fd);
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
+
+	mutex_lock(&event_mutex);
+	list_for_each_entry_safe(raw_tp, next, &file->bpf_attached,
+				 event_attached) {
+		if (raw_tp->prog == prog) {
+			list_del(&raw_tp->event_attached);
+			bpf_raw_tracepoint_close(raw_tp);
+			prog_put = false;
+			break;
+		}
+	}
+	mutex_unlock(&event_mutex);
+
+	if (prog_put)
+		bpf_prog_put(prog);
+	*ppos += cnt;
+	return cnt;
+}
+
+static void *event_bpf_attach_next(struct seq_file *m, void *t, loff_t *pos)
+{
+	struct trace_event_file *file = event_file_data(m->private);
+
+	return seq_list_next(t, &file->bpf_attached, pos);
+}
+
+static void *event_bpf_attach_start(struct seq_file *m, loff_t *pos)
+{
+	struct trace_event_file *event_file;
+
+	/* ->stop() is called even if ->start() fails */
+	mutex_lock(&event_mutex);
+	event_file = event_file_data(m->private);
+	if (unlikely(!event_file))
+		return ERR_PTR(-ENODEV);
+
+	if (list_empty(&event_file->bpf_attached))
+		return NULL;
+
+	return seq_list_start(&event_file->bpf_attached, *pos);
+}
+
+static void event_bpf_attach_stop(struct seq_file *m, void *t)
+{
+	mutex_unlock(&event_mutex);
+}
+
+static int event_bpf_attach_show(struct seq_file *m, void *v)
+{
+	struct bpf_raw_tracepoint *raw_tp;
+
+	raw_tp = list_entry(v, struct bpf_raw_tracepoint, event_attached);
+	seq_printf(m, "prog id: %u\n", raw_tp->prog->aux->id);
+	return 0;
+}
+
+static const struct seq_operations event_bpf_attach_seq_ops = {
+	.start = event_bpf_attach_start,
+	.next = event_bpf_attach_next,
+	.stop = event_bpf_attach_stop,
+	.show = event_bpf_attach_show,
+};
+
+static int event_bpf_attach_open(struct inode *inode, struct file *file)
+{
+	int ret = 0;
+
+	mutex_lock(&event_mutex);
+
+	if (unlikely(!event_file_data(file))) {
+		mutex_unlock(&event_mutex);
+		return -ENODEV;
+	}
+
+	if (file->f_mode & FMODE_READ) {
+		ret = seq_open(file, &event_bpf_attach_seq_ops);
+		if (!ret) {
+			struct seq_file *m = file->private_data;
+
+			m->private = file;
+		}
+	}
+
+	mutex_unlock(&event_mutex);
+
+	return ret;
+}
+
+const struct file_operations event_bpf_attach_fops = {
+	.open = event_bpf_attach_open,
+	.read = seq_read,
+	.write = event_bpf_attach_write,
+	.llseek = default_llseek,
+};
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 005f08629b8b..e33828d24eb2 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1582,6 +1582,7 @@ extern struct list_head ftrace_events;
 
 extern const struct file_operations event_trigger_fops;
 extern const struct file_operations event_hist_fops;
+extern const struct file_operations event_bpf_attach_fops;
 
 #ifdef CONFIG_HIST_TRIGGERS
 extern int register_trigger_hist_cmd(void);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 67851fb66b6b..79420d5efaef 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2018,8 +2018,10 @@ event_create_dir(struct dentry *parent, struct trace_event_file *file)
 		trace_create_file("trigger", 0644, file->dir, file,
 				  &event_trigger_fops);
 
-		trace_create_file("bpf_attach", 0644, file->dir, file,
-				  &bpf_attach_trigger_fops);
+#ifdef CONFIG_BPF_EVENTS
+		trace_create_file("bpf", 0644, file->dir, file,
+				  &event_bpf_attach_fops);
+#endif
 	}
 
 #ifdef CONFIG_HIST_TRIGGERS
@@ -2267,6 +2269,9 @@ trace_create_new_event(struct trace_event_call *call,
 	atomic_set(&file->sm_ref, 0);
 	atomic_set(&file->tm_ref, 0);
 	INIT_LIST_HEAD(&file->triggers);
+#ifdef CONFIG_BPF_EVENTS
+	INIT_LIST_HEAD(&file->bpf_attached);
+#endif
 	list_add(&file->list, &tr->events);
 
 	return file;
-- 
2.22.0.410.gd8fdbe21b5-goog

